#!/usr/bin/env ruby -W0

require File.join(File.dirname(__FILE__), '..', 'lib', 'rails_bundle_tools')


module TextMate
  class ListFactories
    def run!
      search_term = TextMate::UI.request_string(:title => "Find Factory", :prompt => "Factory Name")
      all_names = collect_factory_names
      matches = all_names.select { |name| name =~ /.*#{search_term.gsub(/\W/, '.*')}.*/ }
      matches += all_names.select { |name| name =~ /.*#{search_term.gsub(/\W/, '').split(//).join('.*')}.*/}
      matches.uniq!
      
      if matches.empty?
        TextMate.exit_show_tool_tip "No factories found matching '#{search_term}'"
      else
        selected = TextMate::UI.menu(matches)
        return if selected.nil?
        puts "Factory(:#{matches[selected]}$1)$0"
      end
    end
    
    def collect_factory_names
      names = []
      self.each_factory_line do |line|
        result = line.match(%r@Factory\.define\(:(\w+).*\)@)
        names << result[1] if result
      end
      return names
    end
    
    def each_factory_line
      factory_files = Dir.glob(File.join(RailsPath.new.rails_root, "test", "factories", "*_factory.rb"))
      seen_files = {}
      factory_files.each do |file|
        filename = File.basename(file)
        next if seen_files[filename]
        seen_files[filename] = true
        File.foreach(file) do |line|
          yield line
        end
      end
    end
  end    
end

TextMate::ListFactories.new.run!