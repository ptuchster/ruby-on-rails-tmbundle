#!/usr/bin/env ruby -W0

require File.join(File.dirname(__FILE__), '..', 'lib', 'rails_bundle_tools')


module TextMate
  class ListFactories
    def run!
      search_term = TextMate::UI.request_string(:title => "Find Factory", :prompt => "Factory Name")
      all_names = collect_factory_names
      
      matches = all_names.select { |name| name =~ /.*#{search_term.gsub(/\W/, '.*')}.*/ }
      sort_matches!(matches, search_term)
      
      secondary_matches = all_names.select { |name| name =~ /.*#{search_term.gsub(/\W/, '').split(//).join('.*')}.*/}
      sort_matches!(secondary_matches, search_term)
      
      matches = matches + secondary_matches
      matches.uniq!
            
      if matches.empty?
        TextMate.exit_show_tool_tip "No factories found matching '#{search_term}'"
        print ''
      else
        selected = TextMate::UI.menu(matches)
        if selected.nil?
          print ''
        else
          print "Factory(:#{matches[selected]}$1)$0"
        end
      end
    end
    
    def sort_matches!(matches, search_term)
      matches.sort! do |a, b|
        if a[0,1] == search_term[0,1]
          if b[0,1] == search_term[0,1]
            a <=> b
          else
            -1
          end
        elsif b[0,1] == search_term[0,1]
          1
        else
          a <=> b
        end
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
      factory_files = Dir.glob(File.join(RailsPath.new.rails_root.to_s, "test", "factories", "**/**/*_factory.rb"))
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