package br.com.lojavirtual.controlller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import br.com.lojavirtual.exception.ExceptionMentoriaJava;
import br.com.lojavirtual.model.PessoaJuridica;
import br.com.lojavirtual.repository.PessoaRepository;
import br.com.lojavirtual.service.PessoaUserService;

@Controller
public class PessoaController {
	
	@Autowired
	private PessoaRepository pessoaRepository;
	
	@Autowired
	private PessoaUserService pessoaUserService;

	/*end-point é microservico é api*/
	@ResponseBody
	@PostMapping(value = "**/salvarPj")
	public ResponseEntity<PessoaJuridica> salvarPJ(@RequestBody PessoaJuridica pessoaJuridica) throws ExceptionMentoriaJava{
		
		if(pessoaJuridica == null) {
			throw new ExceptionMentoriaJava("Pesssoa Juridica nao pode ser NULL!");
		}
		
		if(pessoaJuridica.getId() == null 
				&& pessoaRepository.verificaCnpjCadastrado(pessoaJuridica.getCnpj()) != null) {
			throw new ExceptionMentoriaJava("Já existe CNPJ cadastrado com o numero: " + pessoaJuridica.getCnpj());
		}
		
		pessoaJuridica = pessoaUserService.salvarPessoJuridica(pessoaJuridica);
		
		return new ResponseEntity<PessoaJuridica>(pessoaJuridica, HttpStatus.OK);
	}
}
