=begin

This file is part of the http://github.com/tario/ruby-cymbol project, ruby-cymbol

Copyright (c) 2009-2010 Roberto Dario Seminara <robertodarioseminara@gmail.com>

http://github.com/tario/ruby-cymbol is free software: you can redistribute it and/or modify
it under the terms of the gnu general public license as published by
the free software foundation, either version 3 of the license, or
(at your option) any later version.

http://github.com/tario/ruby-cymbol is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.  see the
gnu general public license for more details.

you should have received a copy of the gnu general public license
along with http://github.com/tario/ruby-cymbol.  if not, see <http://www.gnu.org/licenses/>.

=end

module Cymbol
  class Objdump

    attr_accessor :symbols

    class DebugSymbol
      def initialize(name_, offset_)
        @name = name_
        @offset = offset_
      end

      def name
        @name
      end

      def offset
        @offset
      end
    end

    def initialize(path)

      self.symbols = Array.new
  	  #build objdump command
    	# eclipse crash with the \x60 character :S
      objdump_output = eval("\x60objdump -t #{path}\x60")

      # parse objdump output
      objdump_output.each_line do |line|
        words = line.split(" ")
        if words.size > 1 then
          self.symbols << DebugSymbol.new( words[-1], words[0].to_i(16) )
        end
      end
    end
	end
end
