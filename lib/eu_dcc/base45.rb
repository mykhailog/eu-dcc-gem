# frozen_string_literal: true

module EuDcc
  module Base45
    BASE45_CHARSET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:"
    module_function
    def decode45(str)
      buffer = str.split("").map do |char|
        char_index = BASE45_CHARSET.index(char)
        raise ArgumentError, "Malformed base45 string. Unknown character #{char}." if char_index.nil?
        char_index
      end
      bytes = []
      buffer.each_slice(3) do |group|
        x = group[0] + (group[1] || 0) * 45
        if group.length == 3
          multiplier, rest = (x + group[2] * 45 * 45).divmod(256)
          bytes += [multiplier, rest]
        else
          bytes << x
        end
      end
      bytes.pack("C*")
    end
    def encode45(str)
      # sorry but no
      raise NotImplementedError
    end
  end
end
