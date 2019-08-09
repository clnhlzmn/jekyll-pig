
#install ImageMagick
#add gem "mini_magick" to your site's Gemfile
#run gem install mini_magick
#add <site source>/gallery folder with images
#add gallery/ to exclude list in your site's _config.yml
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
            
            if File.directory?(gallery_path)
            
                #array for holding image data for later
                image_data = []
                
                #hash for holding images from mini_magick, file name is key
                images = {}
                
                #determine list of image names
                Dir.entries(gallery_path).each { |file_name| 
                    full_image_path = File.join(gallery_path, file_name)
                    begin 
                        images[file_name] = MiniMagick::Image.open(full_image_path)
                    rescue
                        #not an image
                    end
                }
                
                #make output path(s)
                FileUtils.mkdir_p assets_path unless File.exists? assets_path
                FileUtils.mkdir_p img_path unless File.exists? img_path
                FileUtils.mkdir_p html_path unless File.exists? html_path
                FileUtils.mkdir_p includes_path unless File.exists? includes_path
                
                #for each image
                images.each { |image_name, image| 
                    
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
                        image_date = Date.strptime(image_name[0, 10], "%Y-%m-%d")
                    rescue
                        #get the date from exif or file if available
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
                    file.write('var imageData = ' + image_data.to_json() + ';')
                }
                
            end
        end
    end
end
