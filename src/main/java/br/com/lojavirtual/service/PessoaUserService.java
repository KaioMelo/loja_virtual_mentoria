package br.com.lojavirtual.service;

import java.io.UnsupportedEncodingException;
import java.util.Calendar;
import java.util.Iterator;

import javax.mail.MessagingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import br.com.lojavirtual.model.Endereco;
import br.com.lojavirtual.model.PessoaJuridica;
import br.com.lojavirtual.model.Usuario;
import br.com.lojavirtual.repository.PessoaRepository;
import br.com.lojavirtual.repository.UsuarioRepository;

@Service
public class PessoaUserService {

	@Autowired
	private UsuarioRepository usuarioRepository;
	
	@Autowired
	private PessoaRepository pessoaRepository;
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private ServiceSendEmail serviceSendEmail;
	
	public PessoaJuridica salvarPessoJuridica(PessoaJuridica pessoaJuridica) {
		
//		pessoaJuridica = pessoaRepository.save(pessoaJuridica);
		
		for (Endereco endereco : pessoaJuridica.getEnderecos()) {
		    endereco.setPessoa(pessoaJuridica);
		    endereco.setEmpresa(pessoaJuridica);
		}
		
		pessoaJuridica = pessoaRepository.save(pessoaJuridica);
		
		Usuario usuarioPj = usuarioRepository.findUserByPessoa(pessoaJuridica.getId(), pessoaJuridica.getEmail());
		
		if(usuarioPj == null) {
			
			String constraint = usuarioRepository.consultaConstraintAcesso();
			
			if(constraint != null) {
				jdbcTemplate.execute("BEGIN; ALTER TABLE usuario_acesso DROP CONSTRAINT " + constraint + "; COMMIT;");
			}
			
			usuarioPj = new Usuario();
			usuarioPj.setDataAtualSenha(Calendar.getInstance().getTime());
			usuarioPj.setEmpresa(pessoaJuridica);
			usuarioPj.setPessoa(pessoaJuridica);
			usuarioPj.setLogin(pessoaJuridica.getEmail());
			
			String senha = "" + Calendar.getInstance().getTimeInMillis();
			String senhaCript = new BCryptPasswordEncoder().encode(senha);
			
			usuarioPj.setSenha(senhaCript);
			
			usuarioPj = usuarioRepository.save(usuarioPj);
			
			usuarioRepository.addAcessoUserPJ(usuarioPj.getId());
			usuarioRepository.addAcessoUserPJ(usuarioPj.getId(), "ROLE_ADMIN");
			
			StringBuilder mensagemHtml = new StringBuilder();
			
			mensagemHtml.append("<b>Segue abaixo seus dados de acesso para Loja Virtual</b>");
			mensagemHtml.append("<p>Login: <b>"+ pessoaJuridica.getEmail() +"</b></p>");
			mensagemHtml.append("<p>Senha: <b>"+ senha +"</b></p>");
			mensagemHtml.append("<p>Obrigado!</p>");
			
			try {
				serviceSendEmail.enviarEmailHtml("Acesso gerado para Loja Virtual", mensagemHtml.toString(), pessoaJuridica.getEmail());
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			} catch (MessagingException e) {
				e.printStackTrace();
			}
		}
		
		
		return pessoaJuridica;
	}
}
