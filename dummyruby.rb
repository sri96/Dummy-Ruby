#Dummyruby is a simple dummy text generator written in ruby. It produces dummy text by extracting random paragraphs and
#words from public domain works. Currently it can only generate a given number of paragraphs. We are planning to
#add more functionality

def choose_a_file_randomly(contents_of_the_directory)

  random_number = Random.rand(0...contents_of_the_directory.length)

  file_id = File.open(contents_of_the_directory[random_number], 'r')

  file_contents = file_id.readlines()

  file_id.close

  return file_contents


end

def find_all_whitespaces(file_contents)

  whitespace_index = []

  for current_index in (0...file_contents.length)

    current_row = file_contents[current_index]

    current_row = current_row.strip

    if current_row.empty?

      whitespace_index << current_index


    end

  end

  return whitespace_index

end

def extract_paragraph(passage_start, file_contents)

  starting_index = file_contents.index(passage_start)

  paragraph = [file_contents[starting_index]]

  next_index = starting_index + 1

  next_line = file_contents[next_index]

  next_line = next_line.strip

  while !next_line.empty?

    paragraph << file_contents[next_index]

    next_index = next_index + 1

    next_line = file_contents[next_index]

    next_line = next_line.strip

  end

  return paragraph


end

def find_and_extract_paragraphs(whitespaces, file_contents)

  paragraph_line_counter = 0

  paragraphs = []

  file_contents << "\n"

  for current_index in (0...whitespaces.length)

    whitespaces_index = whitespaces[current_index]

    row_to_be_tested = file_contents[whitespaces_index+1]

    if row_to_be_tested != nil

      row_to_be_tested = row_to_be_tested.strip

      if !row_to_be_tested.empty?

        if row_to_be_tested.length > 40

          new_index = whitespaces_index+2

          new_row_to_be_tested = file_contents[new_index]

          new_row_to_be_tested = new_row_to_be_tested.strip

          paragraph_line_counter = paragraph_line_counter +1

          while !new_row_to_be_tested.empty?

            if new_row_to_be_tested.length > 40

              new_index = new_index + 1

              paragraph_line_counter = paragraph_line_counter + 1

              new_row_to_be_tested = file_contents[new_index]

              new_row_to_be_tested = new_row_to_be_tested.strip

            else

              new_index = new_index + 1

              new_row_to_be_tested = file_contents[new_index]

              new_row_to_be_tested = new_row_to_be_tested.strip


            end


          end


        end

      end

    end

    if paragraph_line_counter > 4

      paragraphs << extract_paragraph(file_contents[whitespaces[current_index]+1], file_contents)

      paragraph_line_counter = 0


    end


  end

  return paragraphs


end

def produce_random_paragraphs(paragraph_array, no_of_paragraphs)

  random_paragraph_index = []

  final_output = []

  for x in (0...no_of_paragraphs)

    random_number = Random.rand(0..paragraph_array.length)

    if random_paragraph_index.index(random_number) != nil

      random_paragraph_index << random_number

    else

      while random_paragraph_index.index(random_number) != nil

        random_number = Random.rand(0..paragraph_array.length)

      end

      random_paragraph_index << random_number

    end


  end

  for y in (0...no_of_paragraphs)

    final_output << paragraph_array[random_paragraph_index[y]]

  end


  return final_output


end

def write_and_open_random_paragraph_file(paragraphs, where_to_save_it)

  while where_to_save_it[-1] == "\\"

    where_to_save_it.pop

  end

  file_name = where_to_save_it+"\\"+"dummytext.txt"

  if File.exists?(file_name)

    file_id = File.open(file_name, 'w')

  else

    file_id = File.new(file_name, 'w')

  end


  for x in (0...paragraphs.length)

    for y in paragraphs[x]

      file_id.puts y




    end

    file_id.puts "\n"

  end

  file_id.close

  system %{cmd /c "start #{file_name}"}

end


def dummy_text_generator(input_choice, no_to_generate, saving_location)

  #Currently, the method provides only one choice for input_choice.

  if input_choice == 1

    current_directory = Dir.pwd

    dir_contents = Dir.glob "*.txt"

    for x in (0..dir_contents.length-1)

      current_row = dir_contents[x]

      current_row = current_directory+"/"+current_row

      dir_contents[x] = current_row


    end

    random_file_contents = choose_a_file_randomly(dir_contents)

    whitespace_index = find_all_whitespaces(random_file_contents)

    last_line = random_file_contents[-1]

    last_line = last_line.strip

    while last_line.empty?

      random_file_contents.pop()

      last_line = random_file_contents[-1]

      last_line = last_line.strip


    end

    paragraph_array = find_and_extract_paragraphs(whitespace_index, random_file_contents)

    randomly_generated_paragraphs = produce_random_paragraphs(paragraph_array, no_to_generate)

    write_and_open_random_paragraph_file(randomly_generated_paragraphs, saving_location)


  end


end


dummy_text_generator(1, 5, "C:\\Users\\Amma\\Desktop")