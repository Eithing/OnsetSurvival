class Item {
    constructor(itemid, type, imageId, ammout, name, desc="") {
        const {
            spriteColonnes,
            space,
            url
        } = CONFIG[type]

        //info sur l'item
        this.element = newEl('div');

        this.element.id = type.toString();

        this.element.classList.add('item');

        this.image = newEl('div');
        this.image.classList.add('item-image')

        this.image.setAttribute("name", name);
        this.image.setAttribute("desc", desc);

        this.image.style.backgroundImage = url;
        this.image.id = imageId;
        let y = Math.floor((imageId - 1) / spriteColonnes) * space
        let x = ((imageId - 1) % spriteColonnes) * space
        this.image.style.backgroundPosition = "-" + x + "px -" + y + "px";

        this.element.appendChild(this.image);

        this.label = newEl('label');
        if (ammout > 999) {
            ammout = "999+"
        }
        this.itemId = itemid
        this.label.innerHTML = ammout.toString(); //set ammout in label
        this.label.classList.add('item-label')
        this.element.appendChild(this.label);
        return this;
    }
}

const CONFIG = {
    'main': {
        spriteLignes: 2,
        spriteColonnes: 2,
        space: 48,
        url: "url('./../../Ressources/images/Admin.jpg')"
    },
    'cloth': {
        spriteLignes: 6,
        spriteColonnes: 5,
        space: 50,
        url: "url('./../../Ressources/images/Cloth.jpg')"
    },
    'weapons': {
        spriteLignes: 5,
        spriteColonnes: 4,
        space: 50,
        url: "url('./../Ressources/images/Weapons.png')"
    },
    'cars': {
        spriteLignes: 5,
        spriteColonnes: 5,
        space: 64,
        url: "url('./../../Ressources/images/Cars.jpg')"
    },
    'consommable': {
        spriteLignes: 3,
        spriteColonnes: 1,
        space: 40,
        url: "url('./../Ressources/images/consommable.png')"
    },
}