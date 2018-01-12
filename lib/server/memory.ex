defmodule Twitter.Server.Memory do

    def create_users_table do
        :ets.new(:user_lookup, [:set, :public, :named_table])
    end

    def register_new_user(username, password) do        
        if check_username(username) == false do
            :ets.insert_new(:user_lookup, {username, password, true, :null, [], [], []})
            {:ok, "User #{username} registered successfully."}
        else
            {:error, "Username #{username} already exist."}
        end
        
    end

    def check_username(username) do
        case :ets.lookup(:user_lookup, username) do
            [{_, _, _, _, _, _, _}] -> true
            [] -> false
        end
    end

    def authenticate_user(username, password, session_Id) do
        case :ets.lookup(:user_lookup, username) do
            [{username, pass, _, id, tweet_list, following_list, follower_list}] -> 
                if pass == password && id == :null do
                    :ets.insert(:user_lookup, {username, password, true, session_Id, tweet_list, following_list, follower_list})
                    {:ok, "Welcome Back #{username}!!"}
                else
                    {:error, "You are already logged in"}
                end                
            [] -> {:error, "Username or password is invalid"}
        end
    end

    def logout_user(username, session_Id) do
        case :ets.lookup(:user_lookup, username) do
            [{username, password, _, id, tweet_list, following_list, follower_list}] ->                
                if session_Id == id do
                    :ets.insert(:user_lookup, {username, password, false, :null, tweet_list, following_list, follower_list})  
                    {:ok, "#{username} successfully logged out"}    
                else
                    {:error, "Unable to logout because the session is invalid"} 
                end          
            [] -> {:error, "Unable to logout #{username}"} 
        end
    end

    def get_tweets(username) do
        case :ets.lookup(:user_lookup, username) do
            [{_, _, _, tweet_list, _, _}] -> {:ok, tweet_list}
            [] -> {:error, "Unable to retrieve tweets because username is invalid"}
        end
    end

    def insert_tweet(username, tweet) do        
        case :ets.lookup(:user_lookup, username) do
            [{username, password, login_state, tweet_list, following_list, follower_list}] -> 
                :ets.insert(:user_lookup, {username, password, login_state, [tweet | tweet_list], following_list, follower_list})
                {:ok, "Tweet successfully sent"}
            [] -> {:error, "Unable to send tweet. Please try again."}
        end       
    end    

    def insert_follower(followed_username, follower_username) do        
        case :ets.lookup(:user_lookup, followed_username) do
            [{username, password, login_state, tweet_list, following_list, follower_list}] -> 
                :ets.insert(:user_lookup, {username, password, login_state, tweet_list, following_list, [follower_username | follower_list]})
                {:ok, ""}
            [] -> {:error, ""}
        end     
    end    
    
    def insert_following(followed_username, follower_username) do        
        case :ets.lookup(:user_lookup, follower_username) do
            [{username, password, login_state, tweet_list, following_list, follower_list}] -> 
                :ets.insert(:user_lookup, {username, password, login_state, tweet_list, [followed_username | following_list], follower_list})
                {:ok, "You have started following #{followed_username}"}
            [] -> {:error, "Unable to follow #{followed_username}"}
        end     
    end

    def remove_follower(followed_username, follower_username) do        
        case :ets.lookup(:user_lookup, followed_username) do
            [{username, password, login_state, tweet_list, following_list, follower_list}] -> 
                follower_list = List.delete(follower_list, follower_username)
                :ets.insert(:user_lookup, {username, password, login_state, tweet_list, following_list, follower_list})
                {:ok, ""}
            [] -> {:error, ""}
        end     
    end    
    
    def remove_following(followed_username, follower_username) do        
        case :ets.lookup(:user_lookup, follower_username) do
            [{username, password, login_state, tweet_list, following_list, follower_list}] -> 
                following_list = List.delete(following_list, followed_username)
                :ets.insert(:user_lookup, {username, password, login_state, tweet_list, following_list, follower_list})
                {:ok, "You have successfully unfollowed #{followed_username}"}
            [] -> {:error, "Unable to unfollow #{followed_username}"}
        end     
    end
end