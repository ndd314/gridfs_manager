module Api
  class FoldersController < ApiController
    def index
      render json: home_folder.sub_folders, each_serializer: FolderSerializer
    end

    def show
      @current_folder ||= Folder.find(params[:id])

      authorize! :manage, @current_folder

      render json: @current_folder.sub_folders, each_serializer: FolderSerializer
    end

    def create
      attributes = params[:folder].symbolize_keys
      parent_folder_id = attributes[:parent_folder_id] || home_folder.id
      attributes = attributes.merge(parent_folder_id: parent_folder_id)
      parent_folder = Folder.find parent_folder_id

      authorize! :manage, parent_folder

      begin
        new_folder = Folder.create!(attributes)
        render json: new_folder
      rescue Mongoid::Errors::Validations => e
        raise StandardError.new(e.message)
      end
    end

    def destroy
      @current_folder ||= Folder.find(params[:id])

      authorize! :manage, @current_folder

      begin
        @current_folder.destroy
        render json: { status: 'success' }
      rescue StandardError => e
        raise StandardError.new(e.message)
      end
    end
  end
end
