#defmodule Web.Component.EmailForm2 do
#  use Web, :live_component
#  use Norm
#  #use Phoenix.HTML
#
#  require Logger
#
#  # schema definition and validation
#
#  #defstruct :email_field, :emails, :norm_errors, :error_messages
#
#  defp s() do
#    schema(%{
#      "email_field" => spec(is_binary() and emails?() and max_emails?(3)),
#      "emails" => coll_of(spec(is_binary()))
#    })
#  end
#
#  defp emails?(field) do
#    emails = split(field)
#
#    Enum.all?(emails, &email?/1)
#  end
#
#  @email ~r/^([A-Z|a-z|0-9](\.|_){0,1})+[A-Z|a-z|0-9]\@([A-Z|a-z|0-9])+((\.){0,1}[A-Z|a-z|0-9]){2}\.[a-z]{2,3}$/
#  defp email?(email) do
#    Regex.match?(@email, email)
#  end
#
#  defp max_emails?(field, max) do
#    emails = split(field)
#    Enum.count(emails) <= max
#  end
#
#  defp split(field) do
#    String.split(field, [" ", ","], trim: true)
#  end
#
#  @impl true
#  def render(assigns) do
#    ~L"""
#    <%= _form = form_for :form, "#",
#      id: "email",
#      phx_target: @myself,
#      phx_change: "email-change",
#      phx_submit: "email-submit" %>
#
#      <label>Send to</label>
#      <input type="text" name="email_field" placeholder="insert up to 3 email addresses">
#      <%= content_tag(:span, extract_error("email_field", @errors), class: "invalid-feedback") %>
#
#      <label>Norm error messages</label>
#      <pre><%= inspect @errors %></pre>
#    </form>
#    """
#  end
#
#  # Event callbacks
#
#  @impl true
#  def mount(socket) do
#    form = %__MODULE__{}
#
#    socket
#    |> assign(:form, form)
#    #|> assign(:emails, [])
#    #|> assign(:errors, [])
#    |> reply(:ok)
#  end
#
#  @impl true
#  def handle_event("email-change", params, socket) do
#    # Here we do casting along with one or multiple
#    # norm schemas
#
#    errors =
#      with {:ok, _} <- Norm.conform(params, s()) do
#        []
#      else
#        {:error, errors} ->
#          handle_errors(errors)
#      end
#
#    socket
#    |> assign(:errors, errors)
#    |> reply(:noreply)
#  end
#
#  def handle_event("email-submit", _params, socket) do
#    socket
#    |> reply(:noreply)
#  end
#
#  # Changeset functions
#
#  defp (email_field) do
#
#    if changeset.valid? do
#      value = Ecto.Changeset.get_field(changeset, :email_field)
#      emails = split(value)
#      Ecto.Changeset.put_change(changeset, :emails, emails)
#    else
#      changeset
#    end
#  end
#
#  # Helper functions
#
#
#  def extract_error(_tag, []), do: ""
#
#  def extract_error(tag, errors) do
#    error = Enum.find(errors, fn %{path: path} -> List.last(path) == tag end)
#
#    if error do
#      error[:message]
#    else
#      ""
#    end
#  end
#end
#
##defmodule Web.NormHelpers do
##
##  [
##    %{path: ["email_field"], spec: "emails?()", message: "Not all entries are emails"
##    %{path: ["email_field"], spec: "max_emails?()", message: "No more than 3 emails"
##    ]
##
##  def handle_errors({:error, norm_errors}, matches, default \\ "invalid") do
##    Enum.map(norm_errors, fn error ->
##      pattern = %{path: error.path, spec: error.spec} = error
##
##      Enum.find(matches, fn match ->
##
##      end
##    end)
##    match =
##      Enum.find(matches, fn match ->
##        Enum.any?(norm_errors, fn error ->
##          match.path == error.path and
##          match.spec == error.spec
##        end)
##      end)
##
##    if match do
##      match.message
##    else
##      default
##    end
##  end
##
##  defp handle_error(errors, matches) do
##    Enum.any?()
##  end
##
##  defp handle_error(error) do
##    case error do
##      error = %{path: ["email_field"], spec: "emails?()"} ->
##        Map.put(error, :message, "Invalid email")
##
##      error = %{path: ["email_field"], spec: "max_emails?(3)"} ->
##        Map.put(error, :message, "No more than 3 emails")
##
##      _ ->
##        Map.put(error, :message, "Invalid")
##    end
##  end
##
##
##  @doc """
##  TODO: Just thinking on this
##  Changeset like validation for norm schemas
##  this leverages Norm conform validation
##  in favor of something like:
##
##    validate_field(%{user: %{name: "Pepe"}}, [user: :name], s(), "emails?()", "invalid")
##
##  or
##
##    validate_field(%{user: %{name: "Pepe"}}, [user: :name], s(), [
##      {"max_emails?(3)", "no more than 3 emails},
##      {"emails?()", "invalid emails"}
##    ])
##
##  """
##  def validate_field(_map, _path, schema, _error_handler, _message) do
##    # build a map from path
##    value = %{}
##
##    case Norm.conform(value, schema) do
##      {:ok, value} ->
##        value
##
##      {:error, _errors} ->
##        # Get spec from errors
##        # Extract a matching spec from error handler
##        # error_handler.(errors)
##        # if match return error message
##        # else return "error"
##        "error"
##    end
##  end
##end
##
