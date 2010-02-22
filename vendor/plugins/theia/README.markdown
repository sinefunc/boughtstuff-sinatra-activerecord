Theia
=====

Simply put, is the Goddess of Forms. 


Example
=======

    - form_for @user do |f|
      
      %fieldset
        = f.label :first_name do
          %span First Name
          = f.text_field :first_name

        = f.label :last_name do
          %span Last Name
          = f.text_field :last_name

This produces the following markup:
  
    <fieldset>
      <label for="user_first_name">
        <span>First Name>
        <input type="text" name="user[first_name]" id="user_first_name" />
      </label>

      <label for="user_last_name">
        <span>Last Name>
        <input type="text" name="user[last_name]" id="user_last_name" />
      </label>
    </fieldset>


Customizing the inline error displayed
======================================

somewhere in your code, (if it's rails best done as an initializer), do:

    class Theia::FormBuilder
      @@inline_error_proc = Proc.new { |error|
        %(<span class='inline-error'>#{error}</span>)
      }
    end

Copyright (c) 2010 [Cyril David], released under the MIT license
