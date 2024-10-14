defmodule SimpleWeb.PetLive.Index do
  use SimpleWeb, :live_view

  alias Simple.Vet
  alias Simple.Vet.Pet

  def render(assigns) do
    ~H"""
    <!-- Pet Form Section -->
    <.simple_form for={@form} id="simple-form" phx-change="validate" phx-submit="save">
      <.input field={@form[:name]} type="text" label="Name" autofocus />
      <.input field={@form[:age]} type="number" label="Age" />
      <.button phx-disable-with="Saving...">Save</.button>
    </.simple_form>
    <!-- Table Section -->
    <h2>Transactions</h2>

    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Age</th>
        </tr>
      </thead>
      <tbody phx-update="stream" id="foo">
        <%= for {dom_id, pet} <- @streams.pets do %>
          <tr id={dom_id}>
            <td><%= pet.name %></td>
            <td><%= pet.age %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Vet.change_pet(%Pet{})

    {:ok,
     socket
     |> assign(:form, to_form(changeset))
     |> stream(:pets, Vet.list_pets())}
  end

  def handle_event("validate", %{"pet" => pet_params}, socket) do
    changeset =
      %Pet{}
      |> Vet.change_pet(pet_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"pet" => pet_params} = _params, socket) do
    case Vet.create_pet(pet_params) do
      {:ok, pet} ->
        changeset = Vet.change_pet(%Pet{})

        {:noreply,
         socket
         |> stream_insert(:pets, pet)
         |> put_flash(:info, "Pet created successfully")
         |> assign(:form, to_form(changeset))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
