import CSI 1.0

Module
{
    id: module
    property int deck: 1
    property bool enabled: true

    StripeProvider { name: "stripe_provider"; channel: module.deck; width: 400; height: 26 }
    Wire { enabled: module.enabled; from: "surface.stripe_info"; to: "stripe_provider.output" }

}
