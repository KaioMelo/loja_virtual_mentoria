package br.com.lojavirtual.repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import br.com.lojavirtual.model.PessoaJuridica;

@Repository
public interface PessoaRepository extends CrudRepository<PessoaJuridica, Long>{

	@Query(value = "SELECT pj FROM PessoaJuridica pj where pj.cnpj = ?1")
	public PessoaJuridica verificaCnpjCadastrado(String cnpj);
}