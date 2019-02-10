require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }
  end

  def start_time
    Time.now
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    if @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter)}
      if english_word?(@word)
        @message = 'an english word... great job!!!'
        @score = @word.size * (1.0 - (Time.now - start_time)).round(2)
      else
        @message = 'not an english word... better try next time!'
        @score = '0'
      end
    else
      @message = 'not in the grid - gotta use the letters we give ya!'
      @score = '0'
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
