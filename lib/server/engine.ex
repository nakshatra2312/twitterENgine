defmodule Twitter.Server.Engine do
    use GenServer
    alias Twitter.Server.Memory

    def start_link do
        Memory.create_users_table
        GenServer.start_link(__MODULE__, %{}, name: :twitter_engine)
    end

    def handle_call({:user_register, username, password}, _from, state) do        
       {:reply, Memory.register_new_user(username, password), state}   
    end

    def handle_call({:user_login, username, password}, _from, state) do
        #session_Id = :crypto.hash(:sha256, username.to) |> Base.encode16
        {:reply, Memory.authenticate_user(username, password, username), state}
    end

    def handle_call({:user_logout, username, session_Id}, _from, state) do
        {:reply, Memory.logout_user(username, session_Id), state}        
    end

    def handle_call({:fetch_tweets, username, session_key}, state) do
        
        {:reply, state}
    end    

    def handle_call({:follow, followed_username, follower_username, follower_session_key}, state) do
        
        {:reply, state}
    end

    def handle_call({:unfollow, followed_username, follower_username, follower_session_key}, state) do
        
        {:reply, state}
    end    
    
    def handle_cast({:send_tweet, username, session_key, tweet}, state) do
        
        {:noreply, state}
    end

    def handle_cast({:retweet, username, session_key, tweet}, state) do
        
        {:noreply, state}
    end    
    
    def handle_call({:search_following_tweet, keyword}, state) do
        
        {:reply, state}
    end

    def handle_call({:search_hashtag, tag}, state) do
        
        {:reply, state}
    end
    
    def handle_call({:search_user, username}, state) do
        
        {:reply, state}
    end    

end