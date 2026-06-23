package br.com.lojavirtual.controlller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import br.com.lojavirtual.model.Acesso;
import br.com.lojavirtual.repository.AcessoRepository;
import br.com.lojavirtual.service.AcessoService;

/*@CrossOrigin(origins = "www.jdevtreinamento.com.br") // Só os usuarios dentro dessa URL poderia acessar as APIs*/
@Controller
public class AcessoController {

	@Autowired
	private AcessoService acessoService;
	
	@Autowired
	private AcessoRepository acessoRepository;
	
	@ResponseBody /*Poder dar um retorno da API*/
	@PostMapping(value = "**/salvarAcesso") /*Mapeando a url para receber um JSON*/
	public ResponseEntity<Acesso> salvarAcesso(@RequestBody Acesso acesso) { /*Recebe o JSON e converte para Objeto*/
		
		Acesso acessoSalvo = acessoService.save(acesso);
		
		return new ResponseEntity<Acesso>(acessoSalvo, HttpStatus.OK);
	}
	
	@ResponseBody /*Poder dar um retorno da API*/
	@PostMapping(value = "**/deleteAcesso") /*Mapeando a url para receber um JSON*/
	public ResponseEntity<?> deleteAcesso(@RequestBody Acesso acesso) { /*Recebe o JSON e converte para Objeto*/
		
		acessoService.delete(acesso.getId());
		
		return new ResponseEntity("Acesso Removido!", HttpStatus.OK);
	}
	
	/*@Secured({"ROLE_ADMIN", "ROLE_GERENTE"}) // Só que tem esses nivel acesso poderia deletar*/
	@ResponseBody /*Poder dar um retorno da API*/
	@DeleteMapping(value = "**/deleteAcessoPorId/{id}") /*Mapeando a url para receber um JSON*/
	public ResponseEntity<?> deleteAcesso(@PathVariable("id") Long id) { /*Recebe o JSON e converte para Objeto*/
		
		acessoRepository.deleteById(id);
		
		return new ResponseEntity("Acesso Removido!", HttpStatus.OK);
	}
	
	@ResponseBody /*Poder dar um retorno da API*/
	@GetMapping(value = "**/obterAcessoPorId/{id}") /*Mapeando a url para receber um JSON*/
	public ResponseEntity<?> obterAcesso(@PathVariable("id") Long id) { /*Recebe o JSON e converte para Objeto*/
		
		Acesso acesso =acessoRepository.getById(id);
		
		return new ResponseEntity(acesso, HttpStatus.OK);
	}
	
	@ResponseBody /*Poder dar um retorno da API*/
	@GetMapping(value = "**/buscarPorDesc/{desc}") /*Mapeando a url para receber um JSON*/
	public ResponseEntity<List<Acesso>> buscarPorDesc(@PathVariable("desc") String descricao) { /*Recebe o JSON e converte para Objeto*/
		
		List<Acesso> acesso =acessoRepository.buscarAcessoDesc(descricao);
		
		return new ResponseEntity<List<Acesso>>(acesso, HttpStatus.OK);
	}
}
