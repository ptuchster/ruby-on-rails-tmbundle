require File.join(File.dirname(__FILE__), 'rails_bundle_tools')

def array_sorted_search(array, search_term, &block)
  block = lambda { |e| e } if block.nil?
  matches = array.select { |name| block.call(name) =~ /.*#{search_term.gsub(/\W/, '.*')}.*/ }
  sort_matches!(matches, search_term)

  secondary_matches = array.select { |name| block.call(name) =~ /.*#{search_term.gsub(/\W/, '').split(//).join('.*')}.*/}
  sort_matches!(secondary_matches, search_term)

  matches = matches + secondary_matches
  matches.uniq!
  return matches
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
