defmodule ContractManagement.ContractContextTest do
  use ContractManagement.DataCase, async: true

  alias ContractManagement.{
    Contract,
    ContractContext,
    LegalPersonContext,
    NaturalPersonContext
  }

  alias Ecto.Changeset

  @natural_person_params %{
    "name" => "name",
    "cpf" => "12345678900",
    "birth_date" => "2000-12-31"
  }

  @address_params %{
    "country" => "BR",
    "state" => "MG",
    "city" => "BH",
    "street" => "rua horizonte",
    "zip_code" => "31123456"
  }

  @legal_person_params %{
    "name" => "name",
    "cnpj" => "11122233344455",
    "address" => @address_params
  }

  @contract_params %{
    "name" => "contrato 22",
    "description" => "descricao do contrato",
    "date" => "2021-01-12"
  }

  describe "create/1" do
    setup do
      {:ok, natural_person} = NaturalPersonContext.create(@natural_person_params)
      {:ok, legal_person} = LegalPersonContext.create(@legal_person_params)

      {:ok, natural_person: natural_person, legal_person: legal_person}
    end

    test "when params are valid", %{natural_person: natural_person, legal_person: legal_person} do
      upload_file = %Plug.Upload{
        path: "test/files/file.pdf",
        filename: "file name",
        content_type: "application/pdf"
      }

      contract_params =
        Map.merge(
          @contract_params,
          %{
            "file_data" => upload_file,
            "legal_people" => legal_person.id,
            "natural_people" => natural_person.id
          }
        )

      assert {:ok, %Contract{}} = ContractContext.create(contract_params)
    end

    test "when file is not a pdf", %{natural_person: natural_person, legal_person: legal_person} do
      upload_file = %Plug.Upload{
        path: "test/files/pic.png",
        filename: "file name",
        content_type: "image/png"
      }

      contract_params =
        Map.merge(
          @contract_params,
          %{
            "file_data" => upload_file,
            "legal_people" => legal_person.id,
            "natural_people" => natural_person.id
          }
        )

      assert {:error, %Changeset{errors: [file_data: {"file must be a pdf type", []}]}} =
               ContractContext.create(contract_params)
    end

    test "when there is some invalid param", %{
      natural_person: natural_person,
      legal_person: legal_person
    } do
      invalid_params =
        Map.merge(
          @contract_params,
          %{
            "file_data" => "string.file",
            "legal_people" => legal_person.id,
            "natural_people" => natural_person.id
          }
        )

      assert {:error,
              %Changeset{
                errors: _erros
              }} = ContractContext.create(invalid_params)
    end

    test "when there is multiple people from same type", %{
      natural_person: natural_person,
      legal_person: legal_person
    } do
      natural_person_params = Map.put(@natural_person_params, "cpf", "12345678999")

      {:ok, natural_person_2} = NaturalPersonContext.create(natural_person_params)

      upload_file = %Plug.Upload{
        path: "test/files/file.pdf",
        filename: "file name",
        content_type: "application/pdf"
      }

      contract_params =
        Map.merge(
          @contract_params,
          %{
            "file_data" => upload_file,
            "legal_people" => legal_person.id,
            "natural_people" => "#{natural_person.id},#{natural_person_2.id}"
          }
        )

      assert {:ok, %Contract{} = contract} = ContractContext.create(contract_params)
      assert Enum.member?(contract.natural_people, natural_person.id)
      assert Enum.member?(contract.natural_people, natural_person_2.id)
    end
  end

  describe "list/1" do
    setup do
      {:ok, natural_person} = NaturalPersonContext.create(@natural_person_params)
      {:ok, legal_person} = LegalPersonContext.create(@legal_person_params)

      {:ok, natural_person: natural_person, legal_person: legal_person}
    end

    test "when function is called with no filter", %{
      natural_person: natural_person,
      legal_person: legal_person
    } do
      upload_file = %Plug.Upload{
        path: "test/files/file.pdf",
        filename: "file name",
        content_type: "application/pdf"
      }

      contract_params =
        Map.merge(
          @contract_params,
          %{
            "file_data" => upload_file,
            "legal_people" => legal_person.id,
            "natural_people" => natural_person.id
          }
        )

      ContractContext.create(contract_params)

      assert {:ok, [%Contract{}]} = ContractContext.list(%{})
    end

    test "when function is called but there is no contract" do
      assert {:ok, []} = ContractContext.list(%{})
    end

    test "when function is called with people filter", %{
      natural_person: natural_person,
      legal_person: legal_person
    } do
      upload_file = %Plug.Upload{
        path: "test/files/file.pdf",
        filename: "file name",
        content_type: "application/pdf"
      }

      contract_params_with_natural =
        Map.merge(
          @contract_params,
          %{
            "file_data" => upload_file,
            "natural_people" => natural_person.id
          }
        )

      contract_params_with_legal =
        Map.merge(
          @contract_params,
          %{
            "file_data" => upload_file,
            "legal_people" => legal_person.id
          }
        )

      ContractContext.create(contract_params_with_natural)
      ContractContext.create(contract_params_with_legal)

      {:ok, [contract] = contracts_list} =
        ContractContext.list(%{"peopleIds" => natural_person.id})

      assert length(contracts_list) == 1
      assert Enum.member?(contract.natural_people, natural_person.id)
    end

    test "when function is called with date filter", %{
      natural_person: natural_person,
      legal_person: legal_person
    } do
      upload_file = %Plug.Upload{
        path: "test/files/file.pdf",
        filename: "file name",
        content_type: "application/pdf"
      }

      contract_params_from_2019 =
        Map.merge(
          @contract_params,
          %{
            "file_data" => upload_file,
            "natural_people" => natural_person.id,
            "date" => "2019-10-10"
          }
        )

      contract_params_from_2020 =
        Map.merge(
          @contract_params,
          %{
            "file_data" => upload_file,
            "legal_people" => legal_person.id,
            "date" => "2020-10-10"
          }
        )

      {:ok, contract_from_2019} = ContractContext.create(contract_params_from_2019)
      ContractContext.create(contract_params_from_2020)

      {:ok, [contract]} = ContractContext.list(%{"dates" => "2018-10-10,2019-11-11"})

      assert contract_from_2019.id == contract.id
    end
  end
end
