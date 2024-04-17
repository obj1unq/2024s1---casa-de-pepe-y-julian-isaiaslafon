object casaDePepeYJulian {
	var property porcentajeViveres = 0
	var montoReparaciones = 0
	var property cuenta = cuentaCorriente
	var estrategia = estrategiaMinima
	
	method estrategia(_estrategia){
		estrategia = _estrategia
	}
		
	method hayViveresSuficientes(){
		return porcentajeViveres >= 40	
	}
	
	method necesitaReparaciones(){
		return montoReparaciones > 0	
	}
	
	method estaEnOrden(){
		return not self.necesitaReparaciones() and self.hayViveresSuficientes()
	}

	method romper(monto){
		montoReparaciones += monto
	}	
	
	method gastoViveres(porcentaje){
		return porcentaje * estrategia.calidad()
	}
	
	method aumentarViveres(porcentaje){
		porcentajeViveres += porcentaje 
	}
	
	method cantidadViveresAlcanzar(porcentaje) {
		return 0.max(porcentaje - porcentajeViveres)
	}
	
	method sePuedeReparar(){
		return cuenta.saldo() >= montoReparaciones + 1000
	}
	
	method realizarReparaciones(){
		cuenta.extraer(montoReparaciones)
		montoReparaciones = 0
	}	
	
	method realizarMantenimiento(){
		estrategia.aplicar(self)
	}
}

object cuentaCorriente{
	var saldo = 0

	method saldo(){
		return saldo
	}

	method tieneSaldo(monto){
		return saldo >= monto	
	}	
	
	method extraer(monto){
		saldo -= monto
	}
	
	method depositar(monto){
		saldo += monto
	}
	
}

object cuentaConGastos{
	var saldo = 0
	var property costoOperativo = 0

	method tieneSaldo(monto){
		return saldo >= monto	
	}
	
	method saldo(){
		return saldo
	}
	
	method extraer(monto){
		saldo -= monto
	}
	
	method depositar(monto){
		saldo += monto - costoOperativo 
	}
}

object cuentaCombinada{
	var property cuentaPrimaria = cuentaConGastos
	var property cuentaSecundaria = cuentaCorriente

	method saldo(){
		return cuentaPrimaria.saldo() + cuentaSecundaria.saldo()
	}
	
	method extraer(monto){
		if (cuentaPrimaria.tieneSaldo(monto)) { 
			cuentaPrimaria.extraer(monto)
		} 
		else { 
			cuentaSecundaria.extraer(monto)
		}
	}
	
	method depositar(monto){
		cuentaPrimaria.depositar(monto)
	}
}

object estrategiaMinima{
	var property calidad = 1 //Neutro del producto
		
	method aplicar(casa){
		if (not casa.hayViveresSuficientes()){
			casa.aumentarViveres(casa.cantidadViveresAlcanzar(40))
		}
	}
}

object estrategiaFull{
	method calidad(){
		return 5
	}

	method aplicarEstrategiaViveres(casa){
		if(casa.estaEnOrden()){
			casa.aumentarViveres(casa.cantidadViveresAlcanzar(100))
		}
		else{
			casa.aumentarViveres(40)
		}
	}
	
	method aplicarEstrategiaReparaciones(casa){
		if(casa.sePuedeReparar()){
			casa.realizarReparaciones()
		}
	}
	
	method aplicar(casa){
		self.aplicarEstrategiaViveres(casa)
		self.aplicarEstrategiaReparaciones(casa)	
	}
}
