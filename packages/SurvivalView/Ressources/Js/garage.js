class Vehicle {
    constructor(id, nom, modelId, imageId) {
        const {
            spriteColonnes,
            space,
            url
        } = CONFIG["cars"]

        this.element = newEl('div');

        this.element.id = id.toString();

        this.element.classList.add('vehicle');

        this.label = newEl('button');
        this.modelId = modelId
        this.label.innerHTML = nom.toString();
        this.label.classList.add('tittle')
        this.element.appendChild(this.label);

        this.image = newEl('div');
        this.image.setAttribute("width", 120)
        this.image.setAttribute("height", 100)
        this.image.classList.add("img")

        this.image.setAttribute("name", nom);
        this.image.setAttribute("model-Id", modelId);

        this.image.style.backgroundImage = url;
        this.image.id = imageId;
        let y = Math.floor((imageId - 1) / spriteColonnes) * space
        let x = ((imageId - 1) % spriteColonnes) * space
        this.image.style.backgroundPosition = "-" + x + "px -" + y + "px";

        this.element.appendChild(this.image);

        this.button = newEl('button');
        this.button.classList.add("button");
        this.button.innerHTML = "Sortir"
        this.button.setAttribute("id", "vehbutton")

        this.button.addEventListener('click', (event) => {
            ue.game.callevent("OnSpawnVehicle", JSON.stringify([id]));
        }, false);

        this.element.appendChild(this.button);
        return this;
    }
}

const CONFIG = {
    'cars': {
        spriteLignes: 5,
        spriteColonnes: 5,
        space: 128,
        url: "url('./../Ressources/images/Cars.jpg')"
    },
}

class Garage {
    constructor() {
        this.element = document.getElementById("allvehicles");
        this.garageinv = {
            element: document.getElementById("allvehicles"),
            vehicles: []
        };
    }

    addVehicle(idUnique, vehicle) {
        this.garageinv.vehicles[idUnique] = vehicle
        vehicle.element.setAttribute("vehicle-id", idUnique);

        this.element.appendChild(vehicle.element);
        return this;
    }

    removeVehicle(vehicleid) {
        this.garageinv.vehicles[vehicleid].element.remove()
        this.garageinv.vehicles[vehicleid] = null
        return this;
    }

    removeAllVehicles() {
        document.getElementById("allvehicles").innerHTML = ""
        this.garageinv.vehicles = []
        return this;
    }
}