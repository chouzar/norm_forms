defmodule Web.Live.Email do
  use Web, :live_view

  require Logger

  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component @socket, Web.Component.EmailForm, id: "email-form" %>

    <%= if Enum.any?(@emails) do %>
    <label>Results</label>
    <ul>
      <%= for email <- @emails do %>
      <li><%= email %></li>
      <% end %>
    </ul>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :emails, [])}
  end

  @impl true
  def handle_info({:email_submit, emails}, socket) do
    IO.inspect emails
    {:noreply, assign(socket, :emails, emails)}
  end

end
