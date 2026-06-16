class RoomsController < ApplicationController
    before_action :authenticate_user!

    def create
        @room = Room.create
        @current_entry = @room.entries.create(user_id: current_user.id)
        @another_entry = @room.entries.create(user_id: params[:room][:entry][:user_id])
        redirect_to room_path(@room)
    end


    def index
    my_room_id = current_user.entries.pluck(:room_id)
    @another_entries = Entry
                        .where(room_id: my_room_id)
                        .where.not(user_id: current_user.id)
                        .preload(room: :messages)
                        .preload(user: { icon_attachment: :blob})
    end

    def show

        
        @room = Room.find(params[:id])
        puts "=============================="
    puts "rooms#show に入りました"
    puts "params[:id]: #{params[:id]}"
    puts "current_user.id: #{current_user.id}"
    puts "room entries: #{@room.entries.pluck(:id, :user_id, :room_id).inspect}"
    puts "=============================="
        if @room.entries.where(user_id: current_user.id).present?
            @messages = @room.messages.all
            @message = Message.new
            @entries = @room.entries
            @another_entry = @room.entries.where.not(user_id: current_user.id).first
        else
        redirect_back(fallback_location: root_path)
        end

        unless @another_entry
        redirect_to root_path, alert: "チャット相手が見つかりません"
        return
        end
    puts "@another_entry: #{@another_entry.inspect}"
    end

end