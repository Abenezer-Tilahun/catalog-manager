require_relative './book'
require_relative './author'
require_relative './music_album'
require_relative './genre'
require_relative './label'
require_relative './game'
require_relative './file_manager'

class CreateClasses
  attr_reader :item_list, :label_list, :genre_list, :author_list
  attr_accessor :menu

  def initialize
    @menu = 'main'
    @file_manager = FileManager.new
    @item_list = { book: [], musicalbum: [], game: [] }
    @label_list = { book: [], musicalbum: [], game: [] }
    @genre_list = { book: [], musicalbum: [], game: [] }
    @author_list = { book: [], musicalbum: [], game: [] }
  end

  def save_files
    instance_variables.each do |var|
      file_name = var.to_s.delete('@')
      file = instance_variable_get(var)
      # instance_variable_get(var).each do |obj|
      #   file.push({ ref: obj, value: to_hash(obj) })
      # end
      @file_manager.save_file("./data/#{file_name}.json", file) if var.size.positive?
    end
  end

  # def recover_files
  #   book_file = get_file('./data/book_list.json')
  #   people_file = get_file('./data/people_list.json')
  #   rental_file = get_file('./data/rental_list.json')
  #   recover_books(book_file)
  #   recover_people(people_file)
  #   recover_rentals(rental_file, book_file, people_file)
  # end

  def add_book(date, publisher, cover_state)
    book = Book.new(date, publisher, cover_state)
    @item_list[:book] << { ref: book, publisher: book.publisher, cover_state: book.cover_state }
  end

  def add_music(name, publish_date, on_spotify)
    music = MusicAlbum.new(name, publish_date, on_spotify)
    @item_list[:musicalbum] << { ref: music, publish_date: music.publish_date, on_spotify: music.on_spotify }
  end

  def add_game(date, multiplayer, last_played)
    game = Game.new(date, multiplayer, last_played)
    @item_list[:game] << { ref: game, multiplayer: game.multiplayer, last_played: game.last_played }
  end

  def add_label(item, title, color)
    label = Label.new(title, color)
    label.add_item(item)
    @label_list[@menu.to_s.to_sym] << { ref: label, title: label.title, color: label.color }
  end

  def create_new_label(item, label_decision)
    puts ''
    if label_decision.downcase == 'new'
      print 'Enter the label title: '
      title = gets.chomp
      print 'Enter the label color: '
      color = gets.chomp
      add_label(item, title, color)
    elsif label_decision.to_i.is_a? Integer
      label_index = label_decision.to_i - 1
      label = @label_list[@menu.to_s.to_sym][label_index][:ref]
      label.add_item(item)
    else
      puts ''
      puts 'Invalid input! Try again!'
      create_new_label(app, item, label_decision)
    end
    puts ''
  end

  def add_genre(item, name)
    genre = Genre.new(name)
    genre.add_item(item)
    @genre_list[@menu.to_s.to_sym] << { ref: genre, title: genre.name }
  end

  def create_new_genre(item, genre_decision)
    puts ''
    if genre_decision.downcase == 'new'
      print 'Enter the Genre type: '
      title = gets.chomp
      add_genre(item, title)
    elsif genre_decision.to_i.is_a? Integer
      genre_index = genre_decision.to_i - 1
      genre = @genre_list[@menu.to_s.to_sym][genre_index][:ref]
      genre.add_item(item)
    else
      puts 'invalid input!'
      create_new_genre(item, genre_decision)
    end
    puts ''
  end

  def add_author(item, first_name, last_name)
    author = Author.new(first_name, last_name)
    author.add_item(item)
    @author_list[@menu.to_s.to_sym] << { ref: author, first_name: author.first_name, last_name: author.last_name }
  end

  def create_new_author(item, author_decision)
    !item[:author].nil? && (
      puts 'This item already has an author'
      return
    )
    if author_decision.downcase == 'new'
      print 'First name: '
      first_name = gets.chomp
      print 'Last name: '
      last_name = gets.chomp
      add_author(item, first_name, last_name)
    elsif author_decision.to_i.is_a? Integer
      author_index = author_decision.to_i - 1
      author = @author_list[@menu.to_s.to_sym][author_index][:ref]
      author.add_item(item)
    else
      puts 'Invaild input!.'
      create_new_author(item, author_decision)
    end
    puts 'Author added!'
  end
end
