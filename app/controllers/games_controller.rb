require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split('')
    puts "Word: #{@word}"
    puts "Letters: #{@letters.join(', ')}"
    puts "Params: #{params.inspect}"

    if word_in_grid?(@word.upcase, @letters)
      if valid_word?(@word)
        @result = "Congratulations! #{@word} is a valid English word!"
      else
        @result = "Sorry, but #{@word} does not seem to be a valid English word."
      end
    else
      @result = "Sorry, but #{@word} can't be built out of #{@letters.join(', ')}"
    end
    puts "Result: #{@result}"
  end

  private

  def word_in_grid?(word, grid)
    word.chars.each do |letter|
      return false if word.count(letter) > grid.count(letter)
    end
    true
  end

  def valid_word?(word)
    response = URI.open("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
