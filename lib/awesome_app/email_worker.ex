defmodule AwesomeApp.EmailWorker do
  use GenServer

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  # Server

  def init(initial_val) do
    Process.send_after(self, :tick, 1000)
    {:ok, 0}
  end

  def handle_info(:tick, val) do
    IO.puts "tick #{val}"
    Process.send_after(self, :tick, 1000)
    {:noreply, val + 1}
  end
end
