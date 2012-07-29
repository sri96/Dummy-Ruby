#Dummyruby is a simple dummy text generator written in ruby. It produces dummy text by extracting random paragraphs and
#words from public domain works.It can produce paragraphs, words and lists. All of them are compatible with markdown.

def choose_a_file_randomly(contents_of_the_directory)

  #This method chooses a file from the directory randomly

  random_number = Random.rand(0...contents_of_the_directory.length)

  file_id = File.open(contents_of_the_directory[random_number], 'r')

  file_contents = file_id.readlines()

  file_id.close

  return file_contents


end

def find_all_whitespaces(file_contents)

  #This method finds all the whitespaces inside a opened file. Whitespaces are necessary to identify paragraphs inside
  #a txt file.

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

  #This method is designed to extract paragraphs from the text files. It starts at the start of paragraph and extracts all
  #the lines until it reaches an empty line.


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

  #This method extracts paragraphs from the opened txt file and returns an array with all the paragraphs

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

def produce_random_paragraphs(paragraph_array, no_of_paragraphs_needed)

  #This method extracts random passages from an array of paragraphs and returns the needed number of array requested by the caller

  random_paragraph_index = []

  final_output = []

  for x in (0...no_of_paragraphs_needed)

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

  for y in (0...no_of_paragraphs_needed)

    final_output << paragraph_array[random_paragraph_index[y]]

  end


  return final_output


end

def write_and_open_random_paragraph_file(paragraphs, where_to_save_it)

  #This method calls method which extracts random passages and writes it a .txt file and opens it automatically for us.

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

def write_paragraphs_as_a_list(paragraphs, where_to_save_it)

  #This method calls method which produces random paragraphs and reformats it as a markdown compatible bulleted list with each line
  #of the paragraph as an element of a list.

  while where_to_save_it[-1] == "\\"

    where_to_save_it.pop

  end

  file_name = where_to_save_it+"\\"+"dummytextlist.txt"

  if File.exists?(file_name)

    file_id = File.open(file_name, 'w')

  else

    file_id = File.new(file_name, 'w')

  end

  for x in (0...paragraphs.length)

    for y in paragraphs[x]

      file_id.puts "* "+ y




    end

    file_id.puts "\n"

  end

  file_id.close

  system %{cmd /c "start #{file_name}"}




end

def write_words(words,where_to_save_it)

  #This method writes the generated number of words in the location in which it was requested to be saved.

  while where_to_save_it[-1] == "\\"

    where_to_save_it.pop

  end

  file_name = where_to_save_it+"\\"+"dummywords.txt"

  if File.exists?(file_name)

    file_id = File.open(file_name, 'w')

  else

    file_id = File.new(file_name, 'w')

  end

  for x in words

     file_id.puts x


  end

  file_id.close

  system %{cmd /c "start #{file_name}"}

end

def find_some_words(paragraph_array,no_of_words_needed)

  #This method produces filler words that are need to bridge the gap between generated words and requested words.

  random_paragraph_index = Random.rand(paragraph_array.length)

  random_paragraph = paragraph_array[random_paragraph_index]

  random_line_index = Random.rand(random_paragraph.length)

  random_line = random_paragraph[random_line_index]

  random_line_tokens = random_line.split(" ")

  needed_line = random_line_tokens[0...no_of_words_needed]

  return needed_line.join(" ")


end


def find_given_amount_of_words(paragraph_array,no_of_words)

  #This method generates the requested amount of words.This uses a different simple word counting algorithm from microsoft word and
  #other commercial word processing software. So if you copy and paste this into word and count the number of words inside the
  #software, it is usually lesser number of words but not a whole lot lesser. This problem will be left unfixed.

  rand_number = Random.rand(paragraph_array.length)

  no_of_words_achieved = false

  no_of_words_extracted = 0

  final_export = []

  while no_of_words_achieved == false

    random_paragraph = paragraph_array[rand_number]

    for x in random_paragraph

      current_row = x

      tokenized_current_row = current_row.split(" ")

      no_of_words_extracted = no_of_words_extracted + tokenized_current_row.length

      if no_of_words_extracted >= no_of_words

         break


      else

        final_export << current_row


      end

    end

    if no_of_words_extracted >= no_of_words

      break

    else

       rand_number = Random.rand(paragraph_array.length)

       final_export << "\n"

    end




  end

  if no_of_words_extracted > no_of_words

    last_row = final_export[-1]

    final_export.delete_at(-1)

    last_row_tokens = last_row.split(" ")

    no_of_words_extracted = no_of_words_extracted - last_row_tokens.length

    final_export << find_some_words(paragraph_array,no_of_words-no_of_words_extracted)




  end

  return final_export


end



def dummy_text_generator(input_choice, no_to_generate, saving_location)

  #This method is the main method which controls all the methods above it. It is the method that you as a user needs to use
  #to generate dummy text.

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


  elsif input_choice == 3

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

    write_paragraphs_as_a_list(randomly_generated_paragraphs,saving_location)



  elsif input_choice == 2

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

    words = find_given_amount_of_words(paragraph_array,no_to_generate)

    write_words(words,saving_location)




  end


end

