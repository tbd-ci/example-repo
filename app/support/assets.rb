require 'erb'
require 'pathname'

# Asset builder
class Assets
  attr_reader :source_path

  def initialize(source_path)
    @source_path = Pathname.new source_path
  end

  def files
    Dir.glob(source_path.join '**', '*').reject(&File.method(:directory?))
  end

  def output_path(path)
    path[(source_path.to_s.length + 1)..-1].sub(/\.erb$/, '')
  end

  def content(file)
      content = File.read(file)
      if file =~ /\.erb$/
        renderer = ERB.new(content)
        content = renderer.result()
      end
      content
  end

  def write_to!(dest_path)
    files.each do |file|
      File.open(output_path(file), 'w') do |f|
        f.write(content(file))
      end
    end
  end

end
