#!/usr/bin/env ruby -W0

require File.join(File.dirname(__FILE__), '..', 'lib', "rails_bundle_tools")
require File.join(ENV['TM_SUPPORT_PATH'], 'lib', 'progress')

module TextMate
  class MigrationHelpers

    MOVE_COLUMN_AFTER_REGEX = /(\s+)move\s+:(\w+),\s+:(\w+),\s+:after\s+=>\s+:(\w+)/

    def convert_move_column_after(migration_file)
      TextMate.call_with_progress(:title => "Processing migration", :message => "Fetching database schema and applying types...") do
        TextMate.exit_show_tool_tip("Please open up a rails project from the project root directory.") unless File.exists?("#{TextMate.project_directory}/config/environment.rb")
        require "#{TextMate.project_directory}/config/environment"
        out = ""
        migration_file.split("\n").each do |line|
          out << process_move_column_line(line) + "\n"
        end
      
        return out
      end
    end
    
    
    private
    
    def process_move_column_line(line)
      return line unless line =~ MOVE_COLUMN_AFTER_REGEX
      result = line.match(MOVE_COLUMN_AFTER_REGEX)
      indentation = result[1]
      table_name = result[2]
      column = result[3]
      after_column = result[4]
      
      type = migration_type(table_name, column)
      out = if type
        "#{indentation}change_column :#{table_name}, :#{column}, :#{type}, :after => :#{after_column}"
      else
        line
      end
      
      return out
    end
    
    def migration_type(table_name, column)
      File.open('/Users/phuibonhoa/Desktop/tmlog.txt', 'w') do |file|
        file.puts Inflector.classify(table_name)
      end
      

      klass = Object.const_get(Inflector.classify(table_name))
      out = klass.columns.detect { |klass_column| klass_column.name == column }
      out = out.type if out
      return out
    end
  end
end