defmodule Twitter.Client.User do
    use GenServer   

    def start_link(name) do

        GenServer.start_link(__MODULE__, [num], name: name)        
    end

    def handle_cast({:login, username, password}, state) do
        
        {:noreply, state}
    end

    def handle_cast({:logout}, state) do
        
        {:noreply, state}
    end    

    def handle_cast({:send_tweet, tweet}, state) do
        
        {:noreply, state}
    end

    def handle_cast({:receive_tweet, tweet}, state) do
        
        {:noreply, state}
    end    

end