# frozen_string_literal: true

def parse_numbers(array)
  number_patterns = {
    " _ \n"\
    "| |\n"\
    '|_|' => '0',

    "   \n"\
    "  |\n"\
    '  |' => '1',

    " _ \n"\
    " _|\n"\
    '|_ ' => '2',

    " _ \n"\
    " _|\n"\
    ' _|' => '3',

    "   \n"\
    "|_|\n"\
    '  |' => '4',

    " _ \n"\
    "|_ \n"\
    ' _|' => '5',

    " _ \n"\
    "|_ \n"\
    '|_|' => '6',

    " _ \n"\
    "  |\n"\
    '  |' => '7',

    " _ \n"\
    "|_|\n"\
    '|_|' => '8',

    " _ \n"\
    "|_|\n"\
    ' _|' => '9'
  }

  numbers = []
  array.each_slice(3) do |line|
    row_numbers = []
    (0...27).step(3) do |i|
      pattern = line.map { |l| l[i, 3] }.join("\n")
      digit = number_patterns[pattern]
      if digit.nil?
        digit = []
        line.each_with_index do |j, l|
          j.size.times do |k|
            lin2 = Marshal.load(Marshal.dump(line))
            if lin2[l][k] == ' '
              lin2[l][k] = '_'
              pattern = lin2.map { |l| l[i, 3] }.join("\n")
              digit << number_patterns[pattern] if number_patterns[pattern]
              lin2[l][k] = '|'
              pattern = lin2.map { |l| l[i, 3] }.join("\n")
              digit << number_patterns[pattern] if number_patterns[pattern]
            elsif lin2[l][k] != "\n"
              lin2[l][k] = ' '
              pattern = lin2.map { |l| l[i, 3] }.join("\n")
              digit << number_patterns[pattern] if number_patterns[pattern]
            end
          end
        end
      end
      row_numbers.<<(digit&.empty? || digit.nil? ? '?' : digit)
    end
    numbers << row_numbers
  end
  numbers.flatten(1)
end

def parse_file(name)
  lines = File.open(name).readlines
  total_numbers = []
  numbers = []
  lines.each_with_index do |line, index|
    next if ((index + 1) % 10).zero?

    numbers.push(line)
    if numbers.length == 3
      total_numbers.push(parse_numbers(numbers))
      numbers = []
    end
  end
  total_numbers
end

def checksum(number)
  return 'ILL' if number.include?('?')

  n = number.reverse
  sum = 0
  n.length.times { |i| sum += n[i].to_i * (i + 1) }
  (sum % 11).zero? ? '' : 'ERR'
end

def ill_case(num)
  x = num.filter_map do |n|
    n if n.is_a?(Array)
  end
  if x.size > 1
    return num.map { |n| n.is_a?(Array) ? '?' : n }.join + ' ILL'
  end

  ans = []
  num.each_with_index do |n, i|
    next unless n.is_a?(Array)

    n.each do |j|
      num2 = Marshal.load(Marshal.dump(num))
      num2[i] = j
      ans.push(num2)
    end
  end
  res = []
  ans.each do |a|
    res << a if checksum(a) == ''
  end
  if res.size > 1 || res.size.zero?
    f = num.map { |n| n.is_a?(Array) ? '?' : n }.join
    return res.size > 1 ? "#{f} AMB" : "#{f} ILL"
  end
  res[0]
end

def err_case(num)
  hash = { '0': [8], '1': [7], '3': [9], '4': [9], '5': [6, 9], '6': [8], '8': [0, 9, 6], '9': [8, 5, 3] }
  res = []
  if checksum(num) != ''
    num.size.times do |n|
      hash[num[n].to_sym].each_with_index do |h, _j|
        num2 = Marshal.load(Marshal.dump(num))
        num2[n] = h
        res << num2 if checksum(num2) == ''
      end
    end

    return "#{num.join}ERR" if res.empty?

    if res.size > 1
      num.map { |n| n.is_a?(Array) ? '?' : n }.join + ' AMB'
    else
      res[0].join
    end
  end
end

def write_parsed_numbers(numbers)
  File.open('output.txt', 'w') do |file|
    numbers.each_with_index do |number, index|
      s = number.filter_map do |n|
        n if n.is_a?(Array)
      end

      if s.size.positive?
        if ill_case(number).include?('ILL') || ill_case(number).include?('AMB')
          file.write("#{ill_case(number)}\n#{"\n" if ((index + 1) % 3).zero?}")
        else
          file.write("#{ill_case(number).join} #{checksum(ill_case(number).join)}\n#{"\n" if ((index + 1) % 3).zero?}")
        end
      else
        temp = err_case(number)
        file.write("#{temp || number.join}\n#{"\n" if ((index + 1) % 3).zero?}")
      end
    end
  end
end

write_parsed_numbers(parse_file('test_input.txt'))