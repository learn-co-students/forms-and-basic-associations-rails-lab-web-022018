# require ''  #shouldnt need to require Notes.rb model
class SongsController < ApplicationController
  # before_action :song_find, only: [:edit,:update]
  # def song_find   #IN PRIVATE
  #   @song = Song.find(params[:id])
  # end
  # def song_params #allow use mass assignment to create/updaet an object
  # params.require(:song).permit(:title,release_year)  #need top level key of song, esle cant continue
  # end #under that top level key song, only look at title,release_year

  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
  end
  ##**************************************
  def new
    @song = Song.new
  end

  def create
    STDERR.puts params
    # @song = Song.create(song_params)
    @song = Song.new(title: song_params[:title])
    #**************find or create artist
    @artist=nil
    if !song_params[:artist_name].nil?
      @artist=Artist.find_or_create_by(name: song_params[:artist_name])
    end #if
    @song.artist = @artist if !@artist.nil?
    #**************end find or create artist
    #**************end  create genre
    @genre=nil
    if !song_params[:genre_id].nil?
      # @genre=Genre.find(id: song_params[:genre_id].to_i)
      @genre=Genre.find(song_params[:genre_id].to_i)
    end #if
    @song.genre = @genre if !@genre.nil?
    #**************end  create genre
    #**************notes_1
    # # @song.notes_1 = song_params[:notes_1] if song_params[:notes_1]
    # @notes_1=nil
    # if !song_params[:notes_1].nil?
    #   # @genre=Genre.find(id: song_params[:genre_id].to_i)
    #   @notes_1=Notes.new(content: song_params[:notes_1])
    # end #if
    # @song.notes_1 = @notes_1 if !@notes_1.nil?
    @note = Note.new(content: song_params[:note_contents][0]) if song_params[:note_contents][0]
    @note2 = Note.new(content: song_params[:note_contents][1]) if song_params[:note_contents][1]
    # @ note << Note.new()#(content: song_params[:note_contents][0]) if song_params[:note_contents][0]
    ######should I use create or new? would @song.note1 save if @song saves?
    # uninitialized constant SongsController::Notes
    #stupid error beased on NOTES when it should be N O T E
    @song.notes << @note if @note
    @song.notes << @note2 if @note2
    #**************end notes_1
    if @song.save
      redirect_to @song
    else
      render :new
    end #save
  end #create


  # Post.create({
  # Song.create({
  #   {
  #     # category_name: params[:post][:category_name],
  #     artist_name: params[:song][:artist_name],
  #     # content: params[:post][:content]
  #     title: params[:song][:title]
  #   }
  #           })

  ##************************************
  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params(*args)
    # params.require(:song).permit(:title,:artist_name,:genre_id,:notes_1)
    # params.require(:song).permit(:title,:artist_name,:genre_id,:note_contents: [])
    params.require(:song).permit(:title,:artist_name,:genre_id,note_contents: [])
  end
end
