
#install ImageMagick
#add gem "mini_magick" to your site's Gemfile
#run gem install mini_magick
#add <site source>/gallery folder with images
#add gallery/ to exclude list in your site's _config.yml
#add gallery.rb to your site's _plugins folder
#run jekyll build

require 'date'
require 'fileutils'
require 'json'
require 'mini_magick'

module GalleryGenerator
    class GalleryGenerator < Jekyll::Generator
    
        def full_size_html(name, date)
            "---\n"                 \
            "layout: post\n"        \
            "title: \"#{name}\"\n"  \
            "date: \"#{date.strftime("%Y-%m-%d %H:%M:%S")}\"\n"   \
            "exclude: true\n"       \
            "---\n"                 \
            "<img src=\"{{site.baseurl}}/assets/img/1024/#{name}\"></img>\n"
        end
        
        #read the image data from the _includes folder
        def get_image_data(includes_path)
            image_data = []
            #read image_data if existing
            if File.exists?(File.join(includes_path, "gallery_data.html"))
                File.open(File.join(includes_path, "gallery_data.html"), 'r') { |file|
                    #get array of image data (drop 'var imageData = ' and ';')
                    image_data = JSON.parse(file.read[16..-2])
                }
            end
            image_data
        end
        
        #read images that require processing from gallery
        def get_images(image_data, gallery_path)
            images = {}
            #determine list of image names
            Dir.entries(gallery_path).each { |file_name| 
                full_image_path = File.join(gallery_path, file_name)
                begin 
                    #only process images that arent already in image_data
                    if image_data.find { |data| data['filename'] == file_name } == nil
                        images[file_name] = MiniMagick::Image.open(full_image_path)
                    else 
                        puts "jekyll-pig: image " << file_name << " has already been processed"
                    end
                rescue
                    #not an image
                    puts "jekyll-pig: " << full_image_path << " is not an image"
                end
            }
            images
        end
        
        def get_image_date(image_name, image)
            image_date = nil
            begin
                exif_date = image.exif['DateTimeOriginal']
                if exif_date == nil
                    #no exif date, try to get from file name
                    image_date = Date.strptime(image_name, "%Y-%m-%d")
                else
                    #try to get the image date from exif
                    image_date = Date.strptime(exif_date, "%Y:%m:%d %H:%M:%S")
                end
            rescue
                #get the date from file if possible
                image_date = ""
            end
            image_date
        end
        
        #create thumbnails and fullsize image assets, and create full size html page for a given image
        def process_image(image_data, image_name, image, img_path, html_path)
            puts "jekyll-pig: processing " << image_name
            #create thumbs
            [1024, 500, 250, 100, 20].each { |size|
                image.resize("x" + size.to_s)
                size_out_path = File.join(img_path, size.to_s)
                FileUtils.mkdir_p size_out_path  unless File.exists? size_out_path 
                image.write(File.join(size_out_path , image_name))
            }
            #get date
            image_date = get_image_date(image_name, image)
            #append data to image_data array
            image_data << 
                {
                    'datetime' => image_date,
                    'filename' => image_name,
                    'aspectRatio' => image.width.to_f / image.height
                }
            #create full size html text
            full_size_html = full_size_html(image_name, image_date)
            #create full size image page html for each image
            File.open(File.join(html_path, image_name + ".html"), 'w') { |file| 
                file.write(full_size_html) 
            }
        end
        
        def generate(site)
            gallery_path = File.join(site.source, "gallery")
            assets_path = File.join(site.source, "assets")
            img_path = File.join(assets_path, "img")
            html_path = File.join(assets_path, "html")
            includes_path = File.join(site.source, "_includes")
            layouts_path = File.join(site.source, "_layouts")
            #check for gallery directory
            if File.directory?(gallery_path)
                #array for holding image data for later
                image_data = get_image_data(includes_path)
                #hash for holding images from mini_magick, file name is key
                images = get_images(image_data, gallery_path)
                #make output path(s)
                FileUtils.mkdir_p assets_path unless File.exists? assets_path
                FileUtils.mkdir_p img_path unless File.exists? img_path
                FileUtils.mkdir_p html_path unless File.exists? html_path
                FileUtils.mkdir_p includes_path unless File.exists? includes_path
                #for each image
                images.each { |image_name, image|
                    process_image(image_data, image_name, image, img_path, html_path)
                }
                #create gallery_data include file
                File.open(File.join(includes_path, "gallery_data.html"), 'w') { |file|
                    image_data = image_data.sort_by { |data| data['datetime'] }
                    file.write('var imageData = ' + image_data.to_json() + ';')
                }
            else 
                puts "jekyll-pig: no gallery at " << gallery_path
            end
        end
    end
end
