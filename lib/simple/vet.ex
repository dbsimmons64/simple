defmodule Simple.Vet do
  alias Simple.Repo
  alias Simple.Vet.Pet

  def list_pets() do
    Pet |> Repo.all()
  end

  def create_pet(params) do
    %Pet{}
    |> Pet.changeset(params)
    |> Repo.insert()
  end

  def change_pet(%Pet{} = pet, attrs \\ %{}) do
    Pet.changeset(pet, attrs)
  end
end
