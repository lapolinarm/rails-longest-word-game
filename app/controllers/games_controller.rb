require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end
  def score
    @word = params[:word].upcase
    @letters = params[:letters].split # Obtener las letras de la cuadrícula
    @match = word_in_grid?(@word, @letters)

    if @match
      @valid_word = valid_english_word?(@word)
      if @valid_word
        @message = "Congratulations! #{@word} is a valid English word!"
      else
        @message = "Sorry but #{@word} is not a valid English word."
      end
    else
      @message = "Sorry but #{@word} can't be built out of #{@letters.join(', ')}."
    end
  end

  private

  def word_in_grid?(word, grid)
    word.chars.all? { |char| word.count(char) <= grid.count(char) }
  end

  def valid_english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
