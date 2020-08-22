defmodule Web.Component.EmailForm do
  use Web, :live_component
  use Norm

  require Logger

  # Form structure and schema definition

  defstruct schema_errors: [], error_messages: [], valid?: false

  defp s() do
    schema(%{
      "email_field" => spec(is_binary() and emails?() and max_emails?(2))
    })
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= _form = form_for :form, "#",
      id: "email",
      phx_target: @myself,
      phx_change: "email-change",
      phx_submit: "email-submit" %>

      <label>Send to</label>
      <%= text_input :form, :email_field, name: "email_field", placeholder: gettext("insert up to %{count} email addresses", count: 2), autofocus: true, autocomplete: "off" %>
      <%= field_error @form, "email_field" %>
      <%= submit "submit" %>
    </form>

    <span>Norm form struct</label>
    <div class="show-off">
      <samp><%= inspect @form %></samp>
    </div>
    """
  end

  # Event callbacks

  @impl true
  def mount(socket) do
    socket
    |> assign(:form, %__MODULE__{})
    |> reply(:ok)
  end

  @impl true
  def handle_event("email-change", params, socket) do
    socket
    |> validate_form(params)
    |> reply(:noreply)
  end

  def handle_event("email-submit", params, socket) do
    emails = params["email_field"] |> split()
    message = {:email_submit, emails}

    socket
    |> send_to(self(), message)
    |> reply(:noreply)
  end

  defp validate_form(socket, params) do
    form =
      with {:ok, _params} <- Norm.conform(params, s()) do
        %__MODULE__{
          valid?: true
        }
      else
        {:error, schema_errors} ->
          %__MODULE__{
            valid?: false,
            schema_errors: schema_errors,
            error_messages: handle_errors(schema_errors)
          }
      end

    assign(socket, :form, form)
  end

  defp send_to(socket, pid, message) do
    if socket.assigns.form.valid? do
      send(pid, message)
    end

    socket
  end

  # Helper functions

  defp emails?(field) do
    emails = split(field)

    Enum.all?(emails, &email?/1)
  end

  @email ~r/^([A-Z|a-z|0-9](\.|_){0,1})+[A-Z|a-z|0-9]\@([A-Z|a-z|0-9])+((\.){0,1}[A-Z|a-z|0-9]){2}\.[a-z]{2,3}$/
  defp email?(email) do
    Regex.match?(@email, email)
  end

  defp max_emails?(field, max) do
    emails = split(field)
    Enum.count(emails) <= max
  end

  defp split(field) do
    String.split(field, [" ", ","], trim: true)
  end

  defp reply(socket, message_reply), do: {message_reply, socket}

  defp handle_errors(schema_errors) do
    Enum.map(schema_errors, &handle_error/1)
  end

  defp handle_error(schema_error) do
    case schema_error do
      error = %{path: ["email_field"], spec: <<"emails?", _::binary>>} ->
        Map.put(error, :message, "Invalid email")

      error = %{path: ["email_field"], spec: <<"max_emails?", _::binary>>} ->
        Map.put(error, :message, "No more than 3 emails")

      error ->
        Map.put(error, :message, "Invalid")
    end
  end

  @doc """
  An error HTML helper function that works along the :error_messages key
  of this module.
  """
  def field_error(form, field) do
    # Find tag by using norm's path and extract :message key
    message =
      form.error_messages
      |> Enum.find(fn %{path: path} -> List.last(path) == field end)
      |> Access.get(:message)

    # Generate a span tag similarly to Phoenix guidelines when using Phoenix.Forms
    # and Ecto.Changesets
    content_tag(:span, message, class: "invalid-feedback")
  end


end
