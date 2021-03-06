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

  module ModuleMethods

    def proc_maps
      File.open("/proc/#{$$}/maps").each_line do |line|
        name = line.split(" ")[-1]
        yield(name)
      end
    end

    def ruby_shared_name
      proc_maps do |shared_name|
        if shared_name =~ /libruby/
          return shared_name
        end
      end

      nil
    end
  end

  class << self
    include ModuleMethods
  end

end
