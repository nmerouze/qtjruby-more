require 'iconv'
require 'cgi'

class String
  def camelize(first_letter = :upper)
    case first_letter
      when :upper then String.camelize(self, true)
      when :lower then String.camelize(self, false)
    end
  end
  
  def underscore
    String.underscore(self)
  end
  
  def self.camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
    else
      lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end
  
  def self.underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
  
  def to_utf8
    Iconv.conv('utf-8', 'iso-8859-1', self)
  end
  
  def encode_html
    CGI.escapeHTML(self)
  end
  
  def decode_html
    CGI.unescapeHTML(self)
  end
end