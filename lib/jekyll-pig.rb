
require 'fileutils'
require 'json'
require 'mini_magick'

module JekyllPig
    
    class SourceGallery
        def initialize(path, name)
            @path = path
            @name = name
        end
        def to_s
            "gallery #{@name} at #{@path}"
        end
        def path
            @path
        end
        def name
            @name
        end
    end

    class JekyllPig < Jekyll::Generator
    
        @@image_cache = {}
    
        @@pig_min_js = '!function(t){"use strict";var i,e,s=(e=!(i=[]),{add:function(t){i.length||window.addEventListener("resize",n),i.push(t)},disable:function(){window.removeEventListener("resize",n)},reEnable:function(){window.addEventListener("resize",n)}});function n(){e||(e=!0,window.requestAnimationFrame?window.requestAnimationFrame(o):setTimeout(o,66))}function o(){i.forEach(function(t){t()}),e=!1}function a(t,i){return this.inRAF=!1,this.isTransitioning=!1,this.minAspectRatioRequiresTransition=!1,this.minAspectRatio=null,this.latestYOffset=0,this.lastWindowWidth=window.innerWidth,this.scrollDirection="down",this.visibleImages=[],this.settings={containerId:"pig",scroller:window,classPrefix:"pig",figureTagName:"figure",spaceBetweenImages:8,transitionSpeed:500,primaryImageBufferHeight:1e3,secondaryImageBufferHeight:300,thumbnailSize:20,urlForSize:function(t,i){return "/img/"+i+"/"+t},onClickHandler:function(t){},getMinAspectRatio:function(t){return t<=640?2:t<=1280?4:t<=1920?5:6},getImageSize:function(t){return t<=640?250:t<=1920?500:500}},function(t,i){for(var e in i){i.hasOwnProperty(e)&&(t[e]=i[e])}}(this.settings,i||{}),this.container=document.getElementById(this.settings.containerId),this.container||console.error("Could not find element with ID "+this.settings.containerId),this.scroller=this.settings.scroller,this.images=this._parseImageData(t),function(t,i,e){var s="#"+t+" {  position: relative;}."+i+"-figure {  background-color: #D5D5D5;  overflow: hidden;  left: 0;  position: absolute;  top: 0;  margin: 0;}."+i+"-figure img {  left: 0;  position: absolute;  top: 0;  height: 100%;  width: 100%;  opacity: 0;  transition: "+e/1e3+"s ease opacity;  -webkit-transition: "+e/1e3+"s ease opacity;}."+i+"-figure img."+i+"-thumbnail {  -webkit-filter: blur(30px);  filter: blur(30px);  left: auto;  position: relative;  width: auto;}."+i+"-figure img."+i+"-loaded {  opacity: 1;}",n=document.head||document.getElementsByTagName("head")[0],o=document.createElement("style");o.type="text/css",o.styleSheet?o.styleSheet.cssText=s:o.appendChild(document.createTextNode(s)),n.appendChild(o)}(this.settings.containerId,this.settings.classPrefix,this.settings.transitionSpeed),this}function r(t,i,e){return this.existsOnPage=!1,this.aspectRatio=t.aspectRatio,this.filename=t.filename,this.index=i,this.pig=e,this.classNames={figure:e.settings.classPrefix+"-figure",thumbnail:e.settings.classPrefix+"-thumbnail",loaded:e.settings.classPrefix+"-loaded"},this}a.prototype._getTransitionTimeout=function(){return 1.5*this.settings.transitionSpeed},a.prototype._getTransitionString=function(){return this.isTransitioning?this.settings.transitionSpeed/1e3+"s transform ease":"none"},a.prototype._recomputeMinAspectRatio=function(){var t=this.minAspectRatio;this.minAspectRatio=this.settings.getMinAspectRatio(this.lastWindowWidth),null!==t&&t!==this.minAspectRatio?this.minAspectRatioRequiresTransition=!0:this.minAspectRatioRequiresTransition=!1},a.prototype._parseImageData=function(t){var s=[];return t.forEach(function(t,i){var e=new r(t,i,this);s.push(e)}.bind(this)),s},a.prototype._computeLayout=function(){var s=parseInt(this.container.clientWidth),n=[],o=0,a=0,r=0;this._recomputeMinAspectRatio(),!this.isTransitioning&&this.minAspectRatioRequiresTransition&&(this.isTransitioning=!0,setTimeout(function(){this.isTransitioning=!1},this._getTransitionTimeout()));var h=this._getTransitionString();[].forEach.call(this.images,function(t,i){if(r+=parseFloat(t.aspectRatio),n.push(t),r>=this.minAspectRatio||i+1===this.images.length){r=Math.max(r,this.minAspectRatio);var e=(s-this.settings.spaceBetweenImages*(n.length-1))/r;n.forEach(function(t){var i=e*t.aspectRatio;t.style={width:parseInt(i),height:parseInt(e),translateX:o,translateY:a,transition:h},o+=i+this.settings.spaceBetweenImages}.bind(this)),n=[],r=0,a+=parseInt(e)+this.settings.spaceBetweenImages,o=0}}.bind(this)),this.totalHeight=a-this.settings.spaceBetweenImages},a.prototype._doLayout=function(){this.container.style.height=this.totalHeight+"px";var t="up"===this.scrollDirection?this.settings.primaryImageBufferHeight:this.settings.secondaryImageBufferHeight,i="down"===this.scrollDirection?this.settings.secondaryImageBufferHeight:this.settings.primaryImageBufferHeight,e=function(t){for(var i=0;isNaN(t.offsetTop)||(i+=t.offsetTop),t=t.offsetParent;){};return i}(this.container),s=this.scroller===window?window.innerHeight:this.scroller.offsetHeight,n=this.latestYOffset-e-t,o=this.latestYOffset-e+s+i;this.images.forEach(function(t){t.style.translateY+t.style.height<n||t.style.translateY>o?t.hide():t.load()}.bind(this))},a.prototype._getOnScroll=function(){var i=this;return function(){var t=i.scroller===window?window.pageYOffset:i.scroller.scrollTop;i.previousYOffset=i.latestYOffset||t,i.latestYOffset=t,i.scrollDirection=i.latestYOffset>i.previousYOffset?"down":"up",i.inRAF||(i.inRAF=!0,window.requestAnimationFrame(function(){i._doLayout(),i.inRAF=!1}))}},a.prototype.enable=function(){return this.onScroll=this._getOnScroll(),this.scroller.addEventListener("scroll",this.onScroll),this.onScroll(),this._computeLayout(),this._doLayout(),s.add(function(){this.lastWindowWidth=this.scroller===window?window.innerWidth:this.scroller.offsetWidth,this._computeLayout(),this._doLayout()}.bind(this)),this},a.prototype.disable=function(){return this.scroller.removeEventListener("scroll",this.onScroll),s.disable(),this},r.prototype.load=function(){this.existsOnPage=!0,this._updateStyles(),this.pig.container.appendChild(this.getElement()),setTimeout(function(){this.existsOnPage&&(this.thumbnail||(this.thumbnail=new Image,this.thumbnail.src=this.pig.settings.urlForSize(this.filename,this.pig.settings.thumbnailSize),this.thumbnail.className=this.classNames.thumbnail,this.thumbnail.onload=function(){this.thumbnail&&(this.thumbnail.className+=" "+this.classNames.loaded)}.bind(this),this.getElement().appendChild(this.thumbnail)),this.fullImage||(this.fullImage=new Image,this.fullImage.src=this.pig.settings.urlForSize(this.filename,this.pig.settings.getImageSize(this.pig.lastWindowWidth)),this.fullImage.onload=function(){this.fullImage&&(this.fullImage.className+=" "+this.classNames.loaded)}.bind(this),this.getElement().appendChild(this.fullImage)))}.bind(this),100)},r.prototype.hide=function(){this.getElement()&&(this.thumbnail&&(this.thumbnail.src="",this.getElement().removeChild(this.thumbnail),delete this.thumbnail),this.fullImage&&(this.fullImage.src="",this.getElement().removeChild(this.fullImage),delete this.fullImage)),this.existsOnPage&&this.pig.container.removeChild(this.getElement()),this.existsOnPage=!1},r.prototype.getElement=function(){return this.element||(this.element=document.createElement(this.pig.settings.figureTagName),this.element.className=this.classNames.figure,this.element.addEventListener("click",function(){this.pig.settings.onClickHandler(this.filename)}.bind(this)),this._updateStyles()),this.element},r.prototype._updateStyles=function(){this.getElement().style.transition=this.style.transition,this.getElement().style.width=this.style.width+"px",this.getElement().style.height=this.style.height+"px",this.getElement().style.transform="translate3d("+this.style.translateX+"px,"+this.style.translateY+"px, 0)"},"function"==typeof define&&define.amd?define([],function(){return a}):"undefined"!=typeof module&&module.exports?module.exports=a:t.Pig=a}("undefined"!=typeof window?window:this);'
    
        def full_size_html(gallery_name, name, date, prev_url, next_url)
            "---\n"                                                                                                                                         \
            "layout: post\n"                                                                                                                                \
            "title: #{name}\n"                                                                                                                              \
            "date: #{date.strftime("%Y-%m-%d %H:%M:%S")}\n"                                                                                                 \
            "permalink: /assets/html/#{gallery_name}/#{name}.html\n"                                                                                        \
            "exclude: true\n"                                                                                                                               \
            "---\n"                                                                                                                                         \
            "<div><a href=\"#{prev_url}\" style=\"display:inline;\">prev</a><a href=\"#{next_url}\" style=\"display:inline; float:right\">next</a></div>\n" \
            "<img src=\"{{site.baseurl}}/assets/img/#{gallery_name}/1024/#{name}\"/>\n"                                                                                     
        end
        
        def gallery_html(id, image_data)
            "<div id='#{id}_pig'></div>\n"                                                                      \
            "<script src='{{site.baseurl}}/assets/js/pig.min.js'></script>\n"                                   \
            "<script>\n"                                                                                        \
            "var #{id}_pig = new Pig(\n"                                                                        \
            "    #{image_data.to_json()},\n"                                                                    \
            "    {\n"                                                                                           \
            "        containerId: '#{id}_pig',\n"                                                               \
            "        classPrefix: '#{id}_pig',\n"                                                               \
            "        urlForSize: function(filename, size) {\n"                                                  \
            "            return '{{site.baseurl}}/assets/img/#{id}/' + size + '/' + filename;\n"                \
            "        },\n"                                                                                      \
            "        onClickHandler: function(filename) {\n"                                                    \
            "            window.location.href = '{{site.baseurl}}/assets/html/#{id}/' + filename + '.html';\n"  \
            "        }\n"                                                                                       \
            "    }\n"                                                                                           \
            ").enable();\n"                                                                                     \
            "</script>"
        end
        
        def image_html_url(gallery_name, image_name)
            "/assets/html/#{gallery_name}/#{image_name}.html"
        end
        
        #read the image data from the _includes folder
        def get_image_data(gallery_name)
            image_data = []
            #read image_data if existing
            if File.exists?(File.join(@data_path, "#{gallery_name}.json"))
                File.open(File.join(@data_path, "#{gallery_name}.json"), 'r') { |file|
                    #get array of image data (drop 'var imageData = ' and ';')
                    image_data = JSON.parse(file.read)
                }
            end
            image_data
        end
        
        #get a list of image file names from a given path
        def get_images(path)
            patterns = ['*.jpg', '*.jpeg', '*.png'].map { |ext| File.join(path, ext) }
            Dir.glob(patterns).map { |filepath| File.basename(filepath) }
        end
        
        def get_image(gallery_path, image_name)
            image = @@image_cache[File.join(gallery_path, image_name)]
            if image == nil
                image = MiniMagick::Image.open(File.join(gallery_path, image_name))
                @@image_cache[File.join(gallery_path, image_name)] = image
            end
            image
        end
        
        def get_image_date(gallery_path, image_name)
            image_date = nil
            begin
                image = get_image(gallery_path, image_name)
                exif_date = image.exif['DateTimeOriginal']
                if exif_date == nil
                    #no exif date, try to get from file name
                    image_date = Time.strptime(image_name, "%Y-%m-%d")
                else
                    #try to get the image date from exif
                    image_date = Time.strptime(exif_date, "%Y:%m:%d %H:%M:%S")
                end
            rescue
                #get the date from file if possible
                image_date = File.mtime(File.join(gallery_path, image_name))
            end
            image_date
        end
        
        def get_previous_url(image_data, gallery_name, image_name)
            index = image_data.index { |data| data['filename'] == image_name }
            index = index - 1
            if index < 0
                index = image_data.length - 1
            end
            image_html_url(gallery_name, image_data[index]['filename'])
        end
        
        def get_next_url(image_data, gallery_name, image_name)
            index = image_data.index { |data| data['filename'] == image_name }
            index = index + 1
            if index >= image_data.length
                index = 0
            end
            image_html_url(gallery_name, image_data[index]['filename'])
        end
        
        #create thumbnails and fullsize image assets
        def process_images(image_data, gallery_id, gallery_path, images)
            #create thumbs
            sizes = [1024, 500, 250, 20]
            sizes.each { |size|
                #output path for current size
                size_out_path = File.join(@img_path, gallery_id, size.to_s)
                FileUtils.mkdir_p size_out_path unless File.exists? size_out_path
                
                #images that have already been processed for the current size
                done_images = get_images(size_out_path)
                #all images in the gallery with the ones already done taken away
                todo_images = images - done_images
                
                #function to get the source path to use for creating the given size thumbnail
                #i.e. use the 500px sized images to make the 250px versions
                source_for_size = -> (size) {
                    index = sizes.index(size)
                    source = gallery_path
                    if index != nil && index != 0
                        source = File.join(@img_path, gallery_id, sizes[index - 1].to_s)
                    end
                    source
                }
                
                #do the processing in a batch
                mog = MiniMagick::Tool::Mogrify.new
                mog.resize("x#{size}>")
                mog.sampling_factor('4:2:0')
                mog.interlace('Plane')
                mog.strip()
                mog.quality('75')
                mog.path(size_out_path)
                source_path = source_for_size.call(size)
                todo_images.each { |todo| mog << File.join(source_path, todo) }
                mog.call
            }
        end
        
        #create full size html page for a given image
        def process_image(image_data, gallery_id, gallery_path, image_name)
            full_size_html_path = File.join(@html_path, gallery_id, image_name + ".html")
            #create full size html if it doesn't exist
            if not File.exists? full_size_html_path
                #get image date
                image_date = get_image_date(gallery_path, image_name)
                #create full size html text
                full_size_html = full_size_html(gallery_id, image_name, image_date, 
                                                get_previous_url(image_data, gallery_id, image_name), 
                                                get_next_url(image_data, gallery_id, image_name))
                File.open(full_size_html_path, 'w') { |file| 
                    file.write(full_size_html) 
                }
            end
        end
        
        def get_paths
            @assets_path = File.join(@site.source, "assets")
            @js_path = File.join(@assets_path, "js")
            @data_path = File.join(@site.source, "_data")
            @img_path = File.join(@assets_path, "img")
            @html_path = File.join(@assets_path, "html")
            @includes_path = File.join(@site.source, "_includes")
        end
        
        def get_galleries
            galleries = []
            config_galleries = Jekyll.configuration({})['galleries']
            if config_galleries != nil
                config_galleries.each do |gallery|
                    full_path = File.join(@site.source, gallery['path'])
                    if File.directory?(full_path)
                        galleries << SourceGallery.new(full_path, gallery['name'])
                    end
                end
            else
                default_gallery_path = File.join(@site.source, 'gallery')
                if File.directory?(default_gallery_path)
                    galleries << SourceGallery.new(default_gallery_path, 'gallery')
                end
            end
            galleries
        end
        
        def make_output_paths
            FileUtils.mkdir_p @assets_path unless File.exists? @assets_path
            FileUtils.mkdir_p @js_path unless File.exists? @js_path
            FileUtils.mkdir_p @img_path unless File.exists? @img_path
            FileUtils.mkdir_p @html_path unless File.exists? @html_path
            FileUtils.mkdir_p @includes_path unless File.exists? @includes_path
            FileUtils.mkdir_p @data_path unless File.exists? @data_path
        end
        
        def augment_image_data(gallery, image_data, images) 
            images.each do |image_name|
                #append data to image_data array if it's not already there
                if not image_data.any? { |data| data['filename'] == image_name }
                    #get image date
                    image_date = get_image_date(gallery.path, image_name)
                    image = get_image(gallery.path, image_name)
                    image_data << 
                        {
                        'datetime' => image_date.to_s,
                        'filename' => image_name,
                        'aspectRatio' => image.width.to_f / image.height
                        }
                end
            end
        end
        
        def generate(site)
            @site = site
            get_paths()
            make_output_paths()
            galleries = get_galleries()
            galleries.each do |gallery|
                
                #make gallery specific html and image output paths
                html_output_path = File.join(@html_path, gallery.name)
                FileUtils.mkdir_p html_output_path unless File.exists? html_output_path
                img_output_path = File.join(@img_path, gallery.name)
                FileUtils.mkdir_p img_output_path unless File.exists? img_output_path
                
                #write pig.min.js to js path
                if not File.exists? File.join(@js_path, 'pig.min.js')
                    File.open(File.join(@js_path, 'pig.min.js'), 'w') { |file| file.write(@@pig_min_js) }
                end
                
                #get image data from _data
                image_data = get_image_data(gallery.name)
                old_image_data = image_data.clone
                
                #get images from gallery
                images = get_images(gallery.path)
                
                #add any additional images to image_data
                augment_image_data(gallery, image_data, images)
                
                #sort image data
                image_data = image_data.sort_by { |data| data['datetime'] }
                
                #create thumbs
                process_images(image_data, gallery.name, gallery.path, images)
                
                images.each do |image_name|
                    #create html assets for each image
                    process_image(image_data, gallery.name, gallery.path, image_name)
                end
                
                if image_data != old_image_data
                    #write image_data
                    File.open(File.join(@data_path, "#{gallery.name}.json"), 'w') { |file|
                        file.write(image_data.to_json)
                    }
                    
                    #save this gallery's includable content
                    File.open(File.join(@includes_path, "#{gallery.name}.html"), 'w') { |file|
                        file.write(gallery_html(gallery.name, image_data))
                    }
                end
            end
        end
    end
end
