package br.com.lojavirtual.security;

import java.nio.charset.StandardCharsets;
import java.util.Date;

import javax.crypto.SecretKey;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

/*Criar a autenticacao e retornar a autenticacao JWT*/
@Service
public class JWTTokenAutenticacaoService {

    private final WebConfigSecurity webConfigSecurity;

	/*Token de validação*/
	private static final long EXPIRATION_TIME = 959990000; /*11 DIAS EM MILISEGUNDOS*/
	
	/*Chave de senha para juntar com JWT*/
	private static final String SECRET = "378402&!@(#-90@)_+@!#$%%9hjs";
	
	private static final String TOKEN_PREFIX = "Bearer";
	
	private static final String HEADER_STRING = "Authorization";

    JWTTokenAutenticacaoService(WebConfigSecurity webConfigSecurity) {
        this.webConfigSecurity = webConfigSecurity;
    }
	
	/*Gera o Token e da a resposta para o cliente com a JWT*/
	public void addAuthentication(HttpServletResponse response, String username) throws Exception{
		
		SecretKey key = Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));
		
		String jwt = Jwts.builder()
	            .subject(username) // Antigo setSubject()
	            .expiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME)) // Antigo setExpiration()
	            .signWith(key) // Antigo signWith(SignatureAlgorithm, String) - O algoritmo é detectado automaticamente pelo tamanho da chave
	            .compact();
		
		String token = TOKEN_PREFIX + " " + jwt;
		
		/*Dá a respota para a tela e para o cliente*/
		response.addHeader(HEADER_STRING, token);
		
		response.getWriter().write("{\"Authorization\": \""+ token +"\"}");
	}
}
