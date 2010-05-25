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

require "ruby-cymbol/shared"
require "ruby-cymbol/objdump"
require "singleton"

module Cymbol

  class SymbolNotFound < Exception

    attr_accessor :symbol_name

    def initialize( symbol_name_ )
      self.symbol_name = symbol_name_
    end
  end

  class ObjdumpNotFoundInSystem < Exception

  end

  class RubyDebugInfoNotFoundInSystem < Exception

  end


  def self.check
    # existence of objdump
    unless system("objdump -H > /dev/null")
      raise ObjdumpNotFoundInSystem.new
    end

    shared_name = Cymbol.ruby_shared_name
    debug_info_name = "/usr/lib/debug/" + shared_name
    if File.exist?(debug_info_name)
      shared_name = debug_info_name
    end

    unless shared_name =~ /debug/
      raise RubyDebugInfoNotFoundInSystem.new
    end

    begin
      Cymbol.resolv("ruby_init")
    rescue SymbolNotFound
      raise RubyDebugInfoNotFoundInSystem.new
    end


  end

  class Resolv

    include Singleton

    def initialize
      shared_name = Cymbol.ruby_shared_name

      # Use debug info of libruby if exists
      debug_info_name = "/usr/lib/debug/" + shared_name

      if File.exist?(debug_info_name)
        shared_name = debug_info_name
      end

      @objdump = Cymbol::Objdump.new( shared_name )
    end

    def resolv( symbol_name )
      match_symbols = @objdump.symbols.select{|s| s.name == symbol_name }

      first_symbol = match_symbols.first

      unless first_symbol
        raise SymbolNotFound.new(symbol_name)
      end

      match_symbols.first.offset
    end
  end

  def self.resolv( symbol_name )
    Cymbol::Resolv.instance.resolv( symbol_name )
  end

  # Check conditions at module load
  Cymbol.check

end
