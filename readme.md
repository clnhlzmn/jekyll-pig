# jekyll-pig

This is a plugin that makes it easy to include progressive image galleries in your Jekyll site. Jekyll-pig is made possible with [minimagick](https://github.com/minimagick/minimagick) and [pig.js](https://github.com/schlosser/pig.js).

# How to use

## 1. install [ImageMagick](https://imagemagick.org)

## 2. add `- jekyll-pig` to the plugins list in your site's `_config.yml`

## 3. install jekyll-pig

Either add `gem jekyll-pig` to your site's `Gemfile` and run `bundle install` or run `gem install jekyll-pig`

## 4. add a section called `galleries` to your site's `_config.yml`

It should look like this:
```
galleries:
    -
        path: <path relative to site root>
        name: <gallery-name>
    -
        <another gallery>
```
These lines tell jekyll-pig where to find your images and how to organize the generated output. `<gallery-name>` shouldn't have any spaces.

## 5. add images to your gallery folders

## 6. add gallery folder paths to exclude list in `_config.yml` and to your `.gitignore`

## use `{% include <gallery-name>.html %}` in your pages and posts to include a the gallery identified by `gallery-name`

## 7. run `jekyll build`

# What happens

## jekyll-pig generates a bunch of content
```
<site root>
├── _data
│   ├── <gallery-name>.json             #data for a specific gallery (one for each gallery)
│   └── ...
├── _includes
│   ├── <gallery-name>.html             #gallery include file (one for each gallery)
│   └── ...
├── assets
│   ├── html
│   │   ├── <gallery-name>
│   │   │   └── <filename>.html         #an html page using layout: page for each image
│   │   └── ...
│   ├── img
│   │   ├── <gallery-name>
│   │   │   ├── 20
│   │   │   │   ├── <filename>.<ext>    #each image resized into various size thumbnails
│   │   │   │   └── ...
│   │   │   ├── 100
│   │   │   │   └── ...
│   │   │   ├── 250
│   │   │   │   └── ...
│   │   │   ├── 500
│   │   │   │   └── ...
│   │   │   └── 1024
│   │   │       └── ...
│   │   └── ...
│   ├── js
│   │   ├── pig.min.js                  #js required for the gallery
│   │   └── ...
│   └── ...
└── ...
```

# What you will see

Wherever you `{% include <gallery-name>.html %}` you will see a progressive image gallery.

Check out [mine](https://colinholzman.xyz/gallery).

# Notes

Each image in a gallery is linked to generated page for that image. The default jekyll theme lists all pages at the top of every page. To keep all your image pages from cluttering your page listing the generate pages include `exclude: true` front matter. You can modify your `header.html` include file like this:

```
{%- if my_page.title and my_page.exclude != true -%}
<a class="page-link" href="{{ my_page.url | relative_url }}">{{ my_page.title | escape }}</a>
{%- endif -%}
```

The above just prevents the page link from appearing if `my_page.exclude` is `true`.
