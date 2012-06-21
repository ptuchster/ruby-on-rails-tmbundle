#!/usr/bin/env ruby -W0

require File.join(File.dirname(__FILE__), '..', 'lib', 'search_utilities')
require File.join(File.dirname(__FILE__), '..', 'lib', 'rails_bundle_tools')

module TextMate
  class ListFactories
    def run!
      search_term = TextMate::UI.request_string(:title => "Find Factory", :prompt => "Factory Name")
      all_names = collect_factory_names
      
      matches = array_sorted_search(all_names, search_term)
            
      if matches.empty?
        TextMate.exit_show_tool_tip "No factories found matching '#{search_term}'"
        print ''
      elsif matches.size == 1
        print "Factory(:#{matches.first}$1)$0"
      else
        selected = TextMate::UI.menu(matches)
        if selected.nil?
          print ''
        else
          print "Factory(:#{matches[selected]}$1)$0"
        end
      end
    end
    

    def collect_factory_names
      names = []
      self.each_factory_line do |line|
        result = line.match(%r!Factory\.define\(?\s*:(\w+).*\)?!)
        result = line.match(%r!factory\s*\(?\s*:(\w+).*\)?!) if result.nil? or result[1].nil?
        names << result[1] if result
      end
      return names
    end
    
    def each_factory_line
      factory_files = Dir.glob(File.join(RailsPath.new.rails_root.to_s, "test", "factories", "**/**/*.rb")) + Dir.glob(File.join(RailsPath.new.rails_root.to_s, "spec", "factories", "**/**/*.rb"))
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