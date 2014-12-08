module Api
  class FoldersController < ApiController
    def index
      render json: home_folder.sub_folders.entries, each_serializer: FolderSerializer
    end

    def create
      begin
        new_folder = Folder.create!(params['folder'].symbolize_keys.merge(parent_folder: home_folder))
        render json: new_folder
      rescue Mongoid::Errors::Validations => e
        raise StandardError.new(e.message)
      end
    end
  end
end
