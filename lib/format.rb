# encoding: utf-8
module Format
  CARRIER_WAVE_CACHE_ID = /\A[0-9\-]+\z/
  CARRIER_WAVE_FILENAME = /\A[0-9\_a-zA-Z]+\.[a-zA-Z]{3,4}\z/

  USERNAME          = /\A([0-9a-z\-\.]+)\z/
  USERNAME_SELECTOR = /([0-9a-z\-\.]+)/
  
  COUNTRY_ISO_3166_1= /\A[A-Z]{2}\z/
  INTEGER           = /\A([0-9]+)\z/
  ROMAN_NUMERAL     = /\A(i||ii|iii|iv|v|vi|vii|viii|ix|x)\z/i
  ALPHA_NUM_DASHES  = /\A[a-z0-9\-]+\z/i
  
  NUM_AND_DASHES    = /\A[0-9\-]+\z/
  NUM_DASHES_SPACES = /\A[0-9\-\ ]+\z/
  WHITE_SPACE       = /[\s+]/
  
  SHA1              = /\A[a-zA-Z0-9]{40}\z/

  ISO_639_1_RE      = /\A([a-z]){2}\z/i
  ISO_639_3_RE      = /\A([a-z]){3}\z/i
  RFC_3066_RE       = /\A([a-z]){2}-([a-z]){4}\z/i

  ISO_3166_2        = /\A([a-z]){2}\z/i
  WEBSITE           = /^((http|https|ftp)\:\/\/)?[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?\/?([a-zA-Z0-9\-\._\?\,\'\/\\\+&amp;%\$#\=~])*$/
  
  URI = /^(http|https|ftp)\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?\/?([a-zA-Z0-9\-\._\?\,\'\/\\\+&amp;%\$#\=~])*$/
  PHONE_NUMBER     = /^\+?[\(\-\)\d]+$/
  
  
  EMAIL_SEPARATORS  = /[\s;,]+/
  EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end

