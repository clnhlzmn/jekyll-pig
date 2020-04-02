Gem::Specification.new do |s|
    s.name        = 'jekyll-pig'
    s.version     = '0.0.3'
    s.date        = '2020-03-04'
    s.summary     = "Jekyll image gallery generator"
    s.description = "Uses ImageMagick and pig.js to create progressive image galleries for Jekyll pages"
    s.authors     = ["Colin Holzman"]
    s.email       = 'me@colinholzman.xyz'
    s.files       = ["lib/jekyll-pig.rb"]
    s.homepage    = 'https://github.com/clnhlzmn/jekyll-pig'
    s.license     = 'MIT'
    s.add_runtime_dependency 'mini_magick', '~> 4.10'
    s.requirements << 'ImageMagick or GraphicsMagick'
end