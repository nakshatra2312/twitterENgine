defmodule Twitter do
  alias Twitter.Server.Engine
  alias Twitter.Client.User
  alias Twitter.Client.UserSupervisor

  def main(args \\ []) do    
    args
    |> parse_string

    receive do          
        
    end    
  end

  defp parse_string(args) do    
    num_users = String.to_integer(Enum.at(args,0))
    Engine.start_link
    local_address = find_local_address()
    server_name = :"twitter-server@#{local_address}"      
    start_distributed(server_name)
    {:ok, _} = UserSupervisor.start_link
    simulate_users(num_users, server_name)

    username1 = generate_client_name("user1", local_address)    
    username2 = generate_client_name("user2", local_address)  
    username3 = generate_client_name("user3", local_address)  
    IO.inspect GenServer.call({username1, server_name}, :test)
    IO.inspect GenServer.call({username2, server_name}, :test)
    IO.inspect GenServer.call({username3, server_name}, :test) 
  end

  def simulate_users(count, server_name) do
    if count > 0 do
      local_address = find_local_address()
      username = generate_client_name("user#{count}", local_address)    
      UserSupervisor.add_user(username)
      IO.inspect GenServer.call({:twitter_engine, server_name}, {:user_register, username, "password"})      
      simulate_users(count - 1, server_name)      
    end
  end

  defp find_local_address do
    {:ok, all_ip} = :inet.getif()
    all_ip_tuple = Enum.filter(all_ip, fn(x) ->      
      Enum.join(Tuple.to_list(Enum.at(Tuple.to_list(x), 0))) != "127001"
    end)
    ip_tuple = Enum.at(Tuple.to_list(Enum.at(all_ip_tuple,0)),0)
    :inet.ntoa(ip_tuple)
  end

  def start_distributed(appname) do
    unless Node.alive?() do
      {:ok, _} = Node.start(appname)
    end       
    Node.set_cookie(:cookieName)    
  end

  defp generate_client_name(name, node_name) do    
    hex = :erlang.monotonic_time() |>
      :erlang.phash2(256) |>
      Integer.to_string(16)
    String.to_atom("#{name}-#{hex}@#{node_name}")
  end    
  
end
