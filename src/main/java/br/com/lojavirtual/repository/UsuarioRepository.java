package br.com.lojavirtual.repository;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import br.com.lojavirtual.model.Usuario;

@Repository
public interface UsuarioRepository extends CrudRepository<Usuario, Long>{
	
	@Query(value = "SELECT u FROM Usuario u WHERE u.login = ?1")
	Usuario findUserByLogin(String login);

	@Query(value = "SELECT u FROM Usuario u WHERE u.pessoa.id = ?1 OR u.login = ?2")
	Usuario findUserByPessoa(Long id, String email);

	@Query(value = "SELECT CONSTRAINT_NAME FROM INFORMATION_SCHEMA.constraint_column_usage \r\n"
			+ "WHERE TABLE_NAME = 'usuario_acesso' AND COLUMN_NAME = 'acesso_id'\r\n"
			+ "AND CONSTRAINT_NAME <> 'unique_acesso_user';", nativeQuery = true)
	String consultaConstraintAcesso();

	@Transactional
	@Modifying
	@Query(value = "INSERT INTO usuario_acesso (usuario_id, acesso_id) "
			+ "values (?1, (SELECT id FROM acesso where descricao = 'ROLE_USER'))", 
			nativeQuery = true)
	void addAcessoUserPJ(Long id);

}
