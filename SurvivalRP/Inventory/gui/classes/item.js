class Item {
    constructor(type, imageId /* cloth | weapons | cars */ ) {
        //info sur l'item
        this.element = newEl('div');
        this.element.id = type.toString();

        this.element.classList.add('item');

        this.image = newEl('img');
        this.image.classList.add('item-image')
            /* j'ai mis des images random, a toi de mettre les tiennes*/
        this.image.src = "./../../Ressources/" + type + "/" + imageId + ".jpg"
            /* switch (type) {
                case "cloth":
                    this.image.src = "./../../Ressources/weapons/1.jpg";
                    break;
                case "weapons":
                    this.image.src = "./../../Ressources/weapons/" + imageId + ".jpg";
                    break;
                case "cars":
                    this.image.src = "./../../Ressources/weapons/3.jpg";
                    break;
                default:
                    //this.image.src = "./../../Ressources/weapons/3.jpg";
            } */
        this.element.appendChild(this.image);
        return this;
    }
}