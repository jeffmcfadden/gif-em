class ImagesController < ApplicationController

  def index

    if params[:untagged].present?
      @images = Image.tagged_with(ActsAsTaggableOn::Tag.all.map(&:to_s), exclude: true)
    elsif params[:q].present?
      @images = Image.tagged_with( params[:q] )
      if @images.size == 1
        redirect_to @images.first and return
      end
    else
      @images = Image.all
    end

    @images = @images.order( created_at: :desc ).page( params[:page] ).per( 24 )

  end

  def show
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])

    if @image.update_attributes( image_params )
      redirect_to @image
    else
      flash[:notice] = "Image failed to save."
      redirect_to @image
    end
  end

  def create
    @image = Image.new( image_params )

    if @image.save
      redirect_to images_path
    else
      flash[:notice] = "Image failed to save."
      redirect_to images_path
    end
  end

  private

  def image_params
    params.require(:image).permit(
            :name,
            :tag_list,
            Image.anaconda_fields_for( :asset )
            )
  end

end
