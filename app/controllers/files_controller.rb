class FilesController < ApplicationController
  def show
    @gridfs_file = GridfsFile.find(params[:id])
    send_data @gridfs_file.data, filename: @gridfs_file.name
  end

  def new
    @current_folder ||= Folder.find(params[:folder_id])
    @gridfs_file = GridfsFile.new
  end

  def create
    uploaded_io = params[:gridfs_file][:file_contents]
    folder_id = params[:gridfs_file][:folder_id]

    begin
      @gridfs_file = GridfsFile.new(folder_id: folder_id, name: uploaded_io.original_filename)
      @gridfs_file.upload!(uploaded_io)
      @gridfs_file.save!
      redirect_to folder_path(id: folder_id), notice: 'File uploaded successfully.'
    rescue StandardError => e
      redirect_to folder_path(id: folder_id), alert: e.message
    end
  end

  def destroy
    begin
      @gridfs_file = GridfsFile.find(params[:id])
      @gridfs_file.destroy
      redirect_to folder_path(@gridfs_file.folder), notice: "Successfully deleted file #{@gridfs_file.name}"
    rescue StandardError => e
      redirect_to folder_path(@gridfs_file.folder), alert: e.message
    end
  end
end
