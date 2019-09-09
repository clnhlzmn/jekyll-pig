
# How to use
1. install [ImageMagick](https://imagemagick.org)
2. add `gem "mini_magick"` to your site's Gemfile
3. run `gem install mini_magick`
4. create a directory called gallery in your site's source location (`<site source>/gallery`)
5. add images to gallery folder
6. add `gallery/` to exclude list in `<site source>/_config.yml`
7. copy `jekyll-pig/gallery.rb` to `<site source>/_plugins/gallery.rb`
8. copy `jekyll-pig/pig.min.js` to `<site source>/assets/js/pig.min.js`, note this is my [slightly modified version](https://github.com/clnhlzmn/pig.js) of pig.js
9. copy `jekyll-pig/gallery.html` to `<site source>/gallery.html`
10. run `jekyll build`

# What will be generated
1. a thumbnail of each image in 20, 100, 250, 500, and 1024 pixel widths in `<site_source>/assets/img/<size>/`
2. an html post of each full size (1024) image in `<site_source>/assets/html` with `exclude` set to true

# What you will see
Visit `yoursite/gallery` for the image grid and click an image to visit the full size version
Check out [mine](colinholzman.xyz/gallery)