
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
                image_data = []
                #read image_data if existing
                if File.exists?(File.join(includes_path, "gallery_data.html"))
                    File.open(File.join(includes_path, "gallery_data.html"), 'r') { |file|
                        #get array of image data (drop 'var imageData = ' and ';')
                        image_data = JSON.parse(file.read[16..-2])
                    }
                end
                
                #hash for holding images from mini_magick, file name is key
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
                        puts "jekyll-pig: unable to open " << full_image_path
                    end
                }
                
                #make output path(s)
                FileUtils.mkdir_p assets_path unless File.exists? assets_path
                FileUtils.mkdir_p img_path unless File.exists? img_path
                FileUtils.mkdir_p html_path unless File.exists? html_path
                FileUtils.mkdir_p includes_path unless File.exists? includes_path
                
                #for each image
                images.each { |image_name, image|
                
                
                    puts "jekyll-pig: processing " << image_name
                    
                    #append data to image_data array
                    image_data << 
                        { 
                            'filename' => image_name, 
                            'aspectRatio' => image.width.to_f / image.height
                        }
                    
                    #create thumbs
                    [1024, 500, 250, 100, 20].each { |size|
                        image.resize("x" + size.to_s)
                        size_out_path = File.join(img_path, size.to_s)
                        FileUtils.mkdir_p size_out_path  unless File.exists? size_out_path 
                        image.write(File.join(size_out_path , image_name))
                    }
                    
                    image_date = ""
                    begin
                        exif_date = image.exif['DateTimeOriginal']
                        if exif_date == nil
                            #no exif date, try to get from file name
                            image_date = Date.strptime(image_name[0, 10], "%Y-%m-%d")
                        else
                            #try to get the image date from exif
                            image_date = Date.strptime(exif_date[0, 10], "%Y:%m:%d")
                        end
                    rescue
                        #get the date from file if possible
                        image_date = ""
                    end
                    
                    full_size_html =
'---
layout: post
title: "' + image_name + '"
date: "' + image_date.to_s + '"
exclude: true
---
<img src="{{site.baseurl}}/assets/img/1024/' + image_name + '"></img>'
                    
                    #create full size image page html for each image
                    File.open(File.join(html_path, image_name + ".html"), 'w') { |file| 
                        file.write(full_size_html) 
                    }
                }
                
                #create gallery_data include file
                File.open(File.join(includes_path, "gallery_data.html"), 'w') { |file|
                    file.write('var imageData = ' + image_data.sort_by { |data| data['filename'] }.to_json() + ';')
                }
                
            else 
                puts "jekyll-pig: no gallery at " << gallery_path
            end
        end
    end
end
