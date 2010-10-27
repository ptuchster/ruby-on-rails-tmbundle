require File.join(File.dirname(__FILE__), 'rails_bundle_tools')

def array_sorted_search(array, search_term, &block)
  block = lambda { |e| e } if block.nil?
  matches = array.select { |name| block.call(name) =~ /.*#{search_term.gsub(/[^a-zA-Z0-9]/, '.*')}.*/i }
  sort_matches!(matches, search_term)

  secondary_matches = array.select { |name| block.call(name) =~ /.*#{search_term.gsub(/[^a-zA-Z0-9]/, '').split(//).join('.*')}.*/i}
  sort_matches!(secondary_matches, search_term)

  matches = matches + secondary_matches
  matches.uniq!
  return matches
end

def sort_matches!(matches, search_term)
  matches.sort! do |a, b|
    a_score = consecutive_matching_letters(a, search_term)
    b_score = consecutive_matching_letters(b, search_term)
    if a_score == b_score
      a <=> b
    else
      b_score <=> a_score
    end
  end
end


def consecutive_matching_letters(a, b)
  a = a.downcase.gsub(/[^a-zA-Z0-9]/, '')
  b = b.downcase.gsub(/[^a-zA-Z0-9]/, '')
  out = 0
  a.split(//).zip(b.split(//)).each do |a_letter, b_letter|
    if a_letter == b_letter
      out += 1
    else
      break
    end
  end
  return out
end